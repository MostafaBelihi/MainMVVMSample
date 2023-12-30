//
//  ProductItemPresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 04/10/2023.
//

import Foundation

@MainActor
class ProductItemPresenter: ProductBasePresenter {
	
	// MARK: - Dependencies

	
	// MARK: - Data
	@Published var item: Product?
	
	// MARK: - View Presentation
	var id: Int { item?.id ?? 0 }
	
	var imageURL: String? { item?.imageURL }
	
	var name: String { item?.displayName ?? "" }
	
	var sellerName: String? { item?.sellerName }
	
	var price: String {
		guard let displayPrice = item?.displayPrice else {
			return "---";
		}
		
		return displayPrice.formatPrice();
	}
	
	var originalPrice: String? {
		if let originalPrice = item?.displayOriginalPrice {
			return originalPrice.formatPrice();
		}
		
		return nil;
	}
	
	var currencyText: String {
		(price.count <= 5 && originalPrice?.count ?? 0 <= 5) ? Localizables.egp.text : Localizables.egp2.text
	}

	var isAvailable: Bool { item?.isAvailable ?? false }

	// SampleSimplification:: 
	var isFavorite: Bool {
		false
//		get { item?.isFavorite ?? false }
//		set { item?.isFavorite = newValue }
	}

	// MARK: - Init
	func config(product: Product?) {
		self.item = product;
	}
}
