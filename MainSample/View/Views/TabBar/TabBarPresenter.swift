//
//  TabBarPresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 14/08/2023.
//

import Foundation

@MainActor
class TabBarPresenter: BasePresenter {
	
	// MARK: - View Presentation
	@Published var tabSelection = Tab.home.rawValue
	@Published var isAnimating = true
	@Published var merchantsListSelectedShopType: ShopType = .grocery
	
	// TODO: Use methods like this to switch tabs
	func showAllMerchantsList(with shopType: ShopType = .grocery) {
		merchantsListSelectedShopType = shopType;
		tabSelection = Tab.merchants.rawValue;
	}
}
