//
//  Product.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 03/04/2023.
//

import Foundation

struct Product {
	var id: Int
	var name: String
	var sellerID: String?
	var sellerName: String?
	
	var sku: String?
	var subCategoryID: Int?
	
	var price: Double
	var originalPrice: Double?
	
	var imageURL: String?
	
	var isAvailable: Bool
	var sellableQuantity: Int
}
