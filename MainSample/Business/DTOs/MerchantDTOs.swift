//
//  MerchantDTOs.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 23/09/2023.
//

import Foundation

struct HomeMerchantProductsDTO
{
	var id: String
	var name: String
	var products: [Product]
}

struct MerchantDetailsDTO
{
	var details: Merchant
	var categories: [Category]
	var offers: PagedList<Product>?
}
