//
//  PProductBusiness.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/03/2023.
//

import Foundation

protocol PProductBusiness {
	func getProducts(listParameters: ProductsListParameters) async throws -> PagedList<Product>
	func getProductDetails(id: Int, storeID: Int, merchantID: String, userID: String?, subCategoryID: Int) async throws -> Product
}
