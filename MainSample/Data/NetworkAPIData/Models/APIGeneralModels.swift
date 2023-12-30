//
//  APIGeneralModels.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 20/03/2023.
//

import Foundation

struct APIGeneralSuccessResponse: Codable {
	var okStringMessage: String
}

// MARK: - APIStore
struct APIStore: Codable {
	var id: Int
	var name: String
}

// MARK: - HomeData
struct APIHomeData: Codable {
	let minRequiredVersion: String?
	
	let hotLine: String
	let minimumOrder: Double
	let shippingExpenses: APIShippingExpenses
	let serviceFee: Double
	
	let cartProductCount: Int
	let lastOrderStatus: Int
	let lastOrderID: Int
	let shippingMethod: Int
	
	let displayName: String?
	let email: String?
	let userType: Int
	let wallet: Double?
}

// MARK: - ShippingExpenses
struct APIShippingExpenses: Codable {
	let shippingValue: Double
	let maximumOrderValueFreeShipping: Double
}

// MARK: - DotNetBanner
struct APIBanner: Codable {
	var id: Int
	var title: String
	var description: String
	var imageUrl: String
	var linkUrl: String?
	var bannerType: Int
	var productId: Int?
	var categoryId: Int?
	var name: String?
	var subCategoryId: Int?
}
