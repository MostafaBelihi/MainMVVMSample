//
//  ProductNetworkAPIData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/03/2023.
//

import Foundation

protocol PProductNetworkAPIData {
	func getProductsList(model: APIProductsListRequest) async throws -> APIPagedList<APIProduct>
	func getProductDetails(model: APIProductDetailsRequest) async throws -> APIProduct
}

class ProductNetworkAPIData: PProductNetworkAPIData {
	
	// MARK: - Dependencies
	private var networkService: AuthorizedRESTNetworkService<APIEndpoints>;
	
	// MARK: - Init
	init() {
		self.networkService = AuthorizedRESTNetworkService<APIEndpoints>();
		self.networkService.config(jsonDecoder: APIConstants.jsonDecoder, jsonEncoder: APIConstants.jsonEncoder);
	}
	
	// MARK: - Functions
	func getProductsList(model: APIProductsListRequest) async throws -> APIPagedList<APIProduct> {
		let response = try await networkService.request(.products(model: model),
														modelType: APIPagedList<APIProduct>.self,
														errorType: APIError.self);
		return response.data;
	}
	
	func getProductDetails(model: APIProductDetailsRequest) async throws -> APIProduct {
		let response = try await networkService.request(.product(model: model),
														modelType: APIProduct.self,
														errorType: APIError.self);
		return response.data;
	}
}
