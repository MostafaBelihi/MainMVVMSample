//
//  UserAuthNetworkAPIData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

protocol PUserAuthNetworkAPIData {
	func loginUser(model: APILoginRequest) async throws -> APIAuthResponse;
	func syncUserDevice(model: APISyncUserDeviceRequest) async throws -> Bool
}

class UserAuthNetworkAPIData: PUserAuthNetworkAPIData {
	
	// MARK: - Dependencies
	private var networkService: AuthorizedRESTNetworkService<APIEndpoints>;

	// MARK: - Init
	init() {
		self.networkService = AuthorizedRESTNetworkService<APIEndpoints>();
		self.networkService.config(jsonDecoder: APIConstants.jsonDecoder, jsonEncoder: APIConstants.jsonEncoder);
	}

	// [deferred]TODO: Add a super class between `RESTNetworkService` and this class to include default error types and other configs
	// MARK: - Functions
	func loginUser(model: APILoginRequest) async throws -> APIAuthResponse {
		let response = try await networkService.request(.login(model: model),
														modelType: APIAuthResponse.self,
														errorType: APIError.self);
		return response.data;
	}

	func syncUserDevice(model: APISyncUserDeviceRequest) async throws -> Bool {
		// SampleSimplification:: Method implementation removed.
		return true;
	}

}
