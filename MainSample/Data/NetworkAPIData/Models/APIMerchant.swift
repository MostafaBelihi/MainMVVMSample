//
//  APIMerchant.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/09/2023.
//

import Foundation

// MARK: - Requests

// MARK: - APIMerchant
struct APIMerchant: Codable {
	var id: String
	var displayName: String
	var shopName: String
	var merchantImage: String?
}

// MARK: - APIMerchantProduct
struct APIMerchantProduct: Codable {
	var id: String
	var displayName: String
	var merchantProducts: [APIProduct]
}
