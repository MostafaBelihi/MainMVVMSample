//
//  MerchantAdapters.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/09/2023.
//

import Foundation

class APIMerchantToMerchantAdapter: TypeAdapter {
	// APIMerchant -> Merchant
	func convert(from model: APIMerchant) -> Merchant {
		return Merchant(
			id: model.id,
			name: model.shopName,
			imageURL: model.merchantImage
		);
	}
}

class APIMerchantProductToHomeMerchantProductsDTOAdapter: TypeAdapter {
	// APIMerchantProduct -> Merchant
	func convert(from model: APIMerchantProduct) -> HomeMerchantProductsDTO {
		let adapterProduct = Adapter(typeAdapter: APIProductToProductAdapter());
		let products = adapterProduct.convert(from: model.merchantProducts);
		
		return HomeMerchantProductsDTO(id: model.id,
									   name: model.displayName,
									   products: products);
	}
}
