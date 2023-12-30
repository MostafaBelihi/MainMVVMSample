//
//  Category.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 30/03/2023.
//

import Foundation

protocol PagedParameters {
	var pageSize: Int { get set }
	var page: Int { get set }
}

struct ListParameters: PagedParameters {
	var pageSize: Int
	var page: Int
	var sortBy: String?
	var sort: String?
	var searchQuery: String?
}

// TODO: Some parameters here must be obtained in the business layer and removed from here. Like: userID, storeID, userType. This struct is related with View. This is why they are obtained from DB, so should not be obtained via the View. I did that with Wishlist functions. Also check the use of `PStoreBusiness` in some Interactors for similar refactorings.
struct ProductsListParameters: PagedParameters {
	var pageSize: Int
	var page: Int
	var userID: String?
	var merchantID: String?
	var categoryID: Int?
	var name: String
	var barCode: String
	var storeID: Int
}
