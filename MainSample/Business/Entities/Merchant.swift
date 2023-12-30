//
//  Merchant.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 11/09/2023.
//

import Foundation

struct Merchant {
	var id: String
	var name: String
	var imageURL: String?
}

enum ShopType: String, CaseIterable {
	case grocery
	case vegetablesAndFruits
	case foodOrBeverages
	case pharmacy
	case electronics
	case mobile
	case clothes
}
