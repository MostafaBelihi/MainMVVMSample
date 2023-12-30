//
//  APIEnums.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/03/2023.
//

import Foundation

// [TechDebt]TODO: Refactor - Higher layers access these types directly despite being beloning to the API. This breaks the Clean Architecture.

enum APIStoreType: Int	{
	case grocery = 1
	case vegetablesAndFruits = 2
	case restaurantOrJuices = 3
	case clothes = 4
	case mobileShop = 5
	case homeElectronics = 6
	case pharmacy = 7
}

enum APIMerchantShippingMethod: Int {
	case merchantShipping = 0
	case myShipping = 1
}

enum APIOrderDeliveryMethod: Int {
	case pickup = 0
	case delivery = 1
}

enum APIOrderShippingMethod: Int {
	case pickup = 0
	case myShipping = 1
	case merchantShipping = 2
}

enum APIPurchasePoint: Int {
	case customerService = 0
	case pos = 1
	case android = 2
	case iOS = 3
	case web = 4
}

enum APIBannerType: Int {
	case product = 0
	case category = 1
	case magazine = 2
	case shareTheApp = 3
}

// This enum has a dedicated business counterpart
enum APIRegisterStoreType: Int {
	case shopOrSmallShop = 1
	case cafeOrRestaurant = 2
}

// This enum has a dedicated business counterpart
enum APIUserType: Int {
	case customer = 0
	case merchant = 1
}

enum APIProductType: Int {
	case defaultProduct = 4
	case scaleProduct = 1
	case sizesAndColors = 9
	case equipment
}

enum APICategoryUserType: Int {
	case all = 0
	case user = 1
	case merchant = 2
}

// This enum has a dedicated business counterpart
enum APIOrderStatus: Int {
	case pending = 0
	case accepted = 7
	case processing = 1
	case readyShipping = 8
	case shipping = 2
	case complete = 3
	case canceled = 4
	case closed = 5
	case failedSync = 6
	case pendingPayment = 9
}

enum APIPaymentDeliveryMethod: Int {
	case cashOnDelivery = 1
	case electronicWallet = 2
	case bankCard = 4
}
