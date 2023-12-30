//
//  ProductInteractor.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/03/2023.
//

import Foundation

class ProductInteractor: PProductBusiness {
	
	// MARK: - Dependencies
	@Inject private var data: PDataRequests
	@Inject private var auth: PAuthenticationManager
	
	// MARK: - Data
	
	
	// MARK: - Init
	
	
	// MARK: - Functions
	func getProducts(listParameters: ProductsListParameters) async throws -> PagedList<Product> {
		return try await data.getProductsPaged(listParameters: listParameters);
	}

	func getProductDetails(id: Int, storeID: Int, merchantID: String, userID: String?, subCategoryID: Int) async throws -> Product {
		return try await data.getProductDetails(id: id, storeID: storeID, merchantID: merchantID, userID: userID, subCategoryID: subCategoryID);
	}

}
