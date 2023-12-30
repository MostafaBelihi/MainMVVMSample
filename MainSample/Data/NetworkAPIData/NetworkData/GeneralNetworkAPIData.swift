//
//  GeneralNetworkAPIData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 20/03/2023.
//

import Foundation

protocol PGeneralNetworkAPIData {
	func getStores() async throws -> [APIStore]
	func getHomeData(userID: String?) async throws -> APIHomeData
	func getBanners() async throws -> [APIBanner]
}

class GeneralNetworkAPIData: PGeneralNetworkAPIData {
	
	// MARK: - Dependencies
	private var networkService: AuthorizedRESTNetworkService<APIEndpoints>;

	// MARK: - Init
	init() {
		self.networkService = AuthorizedRESTNetworkService<APIEndpoints>();
		self.networkService.config(jsonDecoder: APIConstants.jsonDecoder, jsonEncoder: APIConstants.jsonEncoder);
	}

	// MARK: - Functions
	func getStores() async throws -> [APIStore] {
		let response = try await networkService.request(.stores,
														modelType: [APIStore].self,
														errorType: APIError.self);
		return response.data;
	}

	func getHomeData(userID: String?) async throws -> APIHomeData {
		let response = try await networkService.request(.homeData(userID: userID),
														modelType: APIHomeData.self,
														errorType: APIError.self);
		return response.data;
	}

	func getBanners() async throws -> [APIBanner] {
		let response = try await networkService.request(.banners,
														modelType: [APIBanner].self,
														errorType: APIError.self);
		return response.data;
	}

}
