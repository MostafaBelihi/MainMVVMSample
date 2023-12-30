//
//  PDataRequests.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

protocol PDataRequests {
	func getAppGlobalData(userID: String?) async throws -> AppGlobalData
	func getHomeBanners() async throws -> [Banner]

	func saveAppSettings(items: AppSettings)
	func loadAppSettings() -> AppSettings?

	func fetchStores() async throws -> [Store];
	func saveActiveStore(_ item: Store)
	func loadActiveStore() -> Store

	func login(username: String, password: String) async throws -> UserAuth;
	func registerUserDevice(userID: String, deviceToken: String) async throws -> Bool

	func getRecommendedMerchants(storeID: Int) async throws -> [Merchant]
	func getTopMerchantsProducts(storeID: Int) async throws -> [HomeMerchantProductsDTO]

	func getProductsPaged(listParameters: ProductsListParameters) async throws -> PagedList<Product>
	func getProductDetails(id: Int, storeID: Int, merchantID: String, userID: String?, subCategoryID: Int) async throws -> Product
}
