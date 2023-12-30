//
//  MerchantInteractor.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/09/2023.
//

import Foundation

class MerchantInteractor: PMerchantBusiness {
	
	// MARK: - Dependencies
	@Inject private var data: PDataRequests
	@Inject private var storeInteractor: PStoreBusiness

	// MARK: - Functions
	func getRecommendedMerchants() async throws -> [Merchant] {
		let storeID = storeInteractor.getActiveStore().id;
		return try await data.getRecommendedMerchants(storeID: storeID);
	}

	func getTopMerchantsProducts() async throws -> [HomeMerchantProductsDTO] {
		let storeID = storeInteractor.getActiveStore().id;
		return try await data.getTopMerchantsProducts(storeID: storeID);
	}

	func getMerchantDetails(pageSize: Int, pageNo: Int, id: String) async throws -> MerchantDetailsDTO {
		// SampleSimplification:: Dummy Data!!!
		return MerchantDetailsDTO(details: Merchant(id: "0", name: "Dummy Data!!!"),
								  categories: []);
	}

}
