//
//  APIProductModels.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/03/2023.
//

import Foundation

// MARK: - Product Requests
struct APIProductsListRequest: Codable {
	var pageSize: Int = 10
	var pageNo: Int = 1
	var customerId: String?
	var merchantId: String
	var categoryId: Int?
	var storeId: Int
}

struct APIProductDetailsRequest: Codable {
	var productId: Int
	var storeId: Int
	var customerId: String?
	var subCategoryId: Int
	var merchantId: String
}

// MARK: - Product
struct APIProduct: Codable {
	var id: Int
	var merchantId: String?
	var name: String
	var sku: String?
	var subCategoryId: Int
	var price: Double
	var priceAfterDiscount: Double
	var productType: Int?
	var barCode: String?
	var image: String
	var isAvailable: Bool
	var salableQuantity: Double
	var minSaleQty: Double
	var shopName: String
	var shippingMethod: Int
}
