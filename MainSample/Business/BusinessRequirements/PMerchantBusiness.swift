//
//  PMerchantBusiness.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/09/2023.
//

import Foundation

protocol PMerchantBusiness {
	func getRecommendedMerchants() async throws -> [Merchant]
	func getTopMerchantsProducts() async throws -> [HomeMerchantProductsDTO]
	func getMerchantDetails(pageSize: Int, pageNo: Int, id: String) async throws -> MerchantDetailsDTO
}
