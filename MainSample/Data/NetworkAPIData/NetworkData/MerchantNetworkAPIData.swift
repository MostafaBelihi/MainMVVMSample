//
//  MerchantNetworkAPIData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/09/2023.
//

import Foundation

protocol PMerchantNetworkAPIData {
	func getHomeMerchants(storeID: Int) async throws -> [APIMerchant]
	func getHomeMerchantsProducts(storeID: Int) async throws -> [APIMerchantProduct]
}

class MerchantNetworkAPIData: PMerchantNetworkAPIData {
	
	// MARK: - Dependencies
	// TODO: Make a base class to accommodate shared resoureces and dependencies like this
	private var networkService: AuthorizedRESTNetworkService<APIEndpoints>;

	// MARK: - Init
	init() {
		self.networkService = AuthorizedRESTNetworkService<APIEndpoints>();
		self.networkService.config(jsonDecoder: APIConstants.jsonDecoder, jsonEncoder: APIConstants.jsonEncoder);
	}

	// MARK: - Functions
	func getHomeMerchants(storeID: Int) async throws -> [APIMerchant] {
		let response = try await networkService.request(.getHomeMerchants(storeID: storeID),
														modelType: [APIMerchant].self,
														errorType: APIError.self);
		return response.data;
	}

	func getHomeMerchantsProducts(storeID: Int) async throws -> [APIMerchantProduct] {
		let response = try await networkService.request(.getHomeMerchantsProducts(storeID: storeID),
														modelType: [APIMerchantProduct].self,
														errorType: APIError.self);
		return response.data;
	}

}
