//
//  EntitiesPresentation.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 05/07/2023.
//

import Foundation

// Properties here were simplified because of trimmed business for sample code presentation
extension Product {
	var displayName: String {
		return name;
	}
	
	var displayPrice: Double {
		return price;
	}
	
	var displayOriginalPrice: Double? {
		return originalPrice;
	}
}

extension AppSettings {
	var userWalletText: String {
		"\(Math.round(number: userWallet ?? 0, decimalPoints: 2)) \(Localizables.egp.text)"
	}
}

extension ShopType {
	var imageString: String {
		switch self {
			case .grocery:
				return "merch-gorcery";
			case .vegetablesAndFruits:
				return "merch-veg-fruits";
			case .foodOrBeverages:
				return "merch-restaurant-juice";
			case .electronics:
				return "merch-electronics";
			case .mobile:
				return "merch-mobile";
			case .clothes:
				return "merch-clothes";
			case .pharmacy:
				return "merch-pharmacy";
		}
	}
}
