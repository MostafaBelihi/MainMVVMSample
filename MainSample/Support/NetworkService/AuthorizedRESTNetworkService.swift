//
//  AuthorizedRESTNetworkService.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 16/07/2023.
//

import Foundation
import Moya

class AuthorizedRESTNetworkService<Endpoint: TargetType>: RESTNetworkService<Endpoint> {
	
	// MARK: - Dependencies
	@Inject private var auth: PAuthenticationManager
	
	// MARK: - Functions
	override func request<TModel: Decodable, TError: Decodable>(_ request: Endpoint,
																modelType: TModel.Type,
																errorType: TError.Type = String.self) async throws -> HTTPResponse<TModel> {
		
		do {
			let response = try await super.request(request, modelType: modelType, errorType: errorType);
			return response;
		}
		catch let error as DataError<APIError> {
			if (error.type == .unauthorizedUser) {
				auth.clearUserAuthentication();
				await DependencyInjector.shared.auth?.logoutUser();
			}
			
			throw error;
		}
	}
}
