//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Moya

class RESTNetworkService<Endpoint: TargetType>: PNetworkService {
	
	// MARK: - Dependencies
	private var provider: MoyaProvider<Endpoint>;
	@Inject private var logger: Logging;
	@Inject private var dataCoder: PDataCoder;
	@Inject private var connection: Connectivity;

	// MARK: - More Variables
	let logErrorResponseTitle = "Error Response";
	let isEnabledProviderLogger = true;
	
	// MARK: - Init
	init() {
		if (isEnabledProviderLogger) {
			self.provider = MoyaProvider<Endpoint>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))]);
		}
		else {
			self.provider = MoyaProvider<Endpoint>();
		}
	}

	func config(jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder) {
		dataCoder.config(jsonDecoder: jsonDecoder, jsonEncoder: jsonEncoder);
	}

	// MARK: - Functions
	/// Closure-based.
	func request<TModel: Decodable, TError: Decodable>(_ request: Endpoint,
													   completion: @escaping HTTPResponseClosure<TModel, TError>) {
		
		//- Error Handling: No connection
		guard connection.isConnected else {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
			let httpResponse = HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .noConnection)), statusCode: 0);
			completion(httpResponse);
			return;
		}

		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Service Request", "\(request.baseURL)/\(request.path)");
		provider.request(request) { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let response):
					completion(self.successHandler(response: response));
					
				case .failure(let error):
					completion(self.moyaFailureHandler(error: error));
			}
		}
	}
	
	/// Async-based.
	func request<TModel: Decodable, TError: Decodable>(_ request: Endpoint,
													   modelType: TModel.Type,
													   errorType: TError.Type = String.self) async throws -> HTTPResponse<TModel> {
		
		return try await withCheckedThrowingContinuation({ continuation in
			//- Error Handling: No connection
			guard connection.isConnected else {
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
				continuation.resume(throwing: DataError<Any>(ofType: .noConnection));
				return;
			}

			logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Service Request", "\(request.baseURL)/\(request.path)");
			provider.request(request) { [weak self] result in
				guard let self = self else { return }
				
				var processedResponse: HTTPResponseResult<TModel, TError>!
				
				// Check Moya Result
				switch result {
					case .success(let response):
						processedResponse = self.successHandler(response: response);
						
					case .failure(let error):
						processedResponse = self.moyaFailureHandler(error: error);
				}
				
				// Check my Result
				switch processedResponse.result {
					case .success(let data):
						let httpResponse = HTTPResponse(data: data,
														statusCode: processedResponse.statusCode,
														headers: processedResponse.headers);
						continuation.resume(returning: httpResponse);
						
					case .failure(let error):
						continuation.resume(throwing: error);
				}
			}
		});
	}
	
	/// Handle Moya response.
	func successHandler<TModel: Decodable, TError: Decodable>(response: Response) -> HTTPResponseResult<TModel, TError> {
		// Debug Prints
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "successHandler", "Moya Success");
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Service Response", response);
		
		// Build response
		let statusCode = response.statusCode;
		let headers = response.response?.headers;
		
		// Handle Response
		switch statusCode {
			case 200..<299:
				// Decoding
				var model: TModel?
				
				// TODO: This is a temp solution to parse string response, review it
				if (TModel.self == String.self) {
					model = String(data: response.data, encoding: .utf8) as? TModel
				}
				else {
					model = dataCoder.decodeModel(ofType: TModel.self, from: response.data);
				}
				
				if let model = model {
					return HTTPResponseResult<TModel, TError>(result: .success(model), statusCode: statusCode, headers: headers);
				}
				else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.decodingError.rawValue);
					return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .decodingError)), statusCode: statusCode, headers: headers);
				}
				
			case 401, 403:
				// Decoding
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.unauthorizedUser.rawValue);
				let model = dataCoder.decodeModel(ofType: TError.self, from: response.data);
				
				if let model = model {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logErrorResponseTitle, model);
					return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .unauthorizedUser, error: model)), statusCode: statusCode, headers: headers);
				}
				else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.decodingError.rawValue);
					return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .unauthorizedUser)), statusCode: statusCode, headers: headers);
				}
				
			case 404:
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.invalidEndpoint.rawValue);
				return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .invalidEndpoint)), statusCode: statusCode, headers: headers);
				
			default:
				//- Error Handling: No connection
				guard connection.isConnected else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
					return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .noConnection)), statusCode: 0);
				}

				// Decoding
				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.serviceError.rawValue);
				let model = dataCoder.decodeModel(ofType: TError.self, from: response.data);
				
				if let model = model {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: logErrorResponseTitle, model);
					return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .serviceError, error: model)), statusCode: statusCode, headers: headers);
				}
				else {
					logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.decodingError.rawValue);
					return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .decodingError)), statusCode: statusCode, headers: headers);
				}
		}
		
	}
	
	/// Handle Moya response.
	func moyaFailureHandler<TModel: Decodable, TError: Decodable>(error: MoyaError) -> HTTPResponseResult<TModel, TError> {
		// Debug Prints
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "moyaFailureHandler", "Moya Failure");
		logger.log(ofType: .debug, file: #file, function: #function, line: "\(#line)", title: "Moya Error", error);
		
		//- Error Handling: No connection
		guard connection.isConnected else {
			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "", ErrorType.noConnection.rawValue);
			return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .noConnection)), statusCode: 0);
		}

		// Response
		return HTTPResponseResult<TModel, TError>(result: .failure(DataError(ofType: .moyaFailure)), statusCode: 0, headers: .none);
	}
}
