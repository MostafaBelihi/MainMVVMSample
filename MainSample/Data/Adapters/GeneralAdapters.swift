//
//  GeneralAdapters.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 20/03/2023.
//

import Foundation

class APIStoreToStoreAdapter: TypeAdapter {
	// APIStore -> Store
	func convert(from model: APIStore) -> Store {
		return Store(id: model.id, name: model.name);
	}
}

class StoreToAPIStoreAdapter: TypeAdapter {
	// Store -> APIStore
	func convert(from model: Store) -> APIStore {
		return APIStore(id: model.id, name: model.name);
	}
}

class APIBannerToBannerAdapter: TypeAdapter {
	// APIBanner -> Banner
	func convert(from model: APIBanner) -> Banner {
		return Banner(id: model.id,
					  title: model.title,
					  image: model.imageUrl,
					  url: model.linkUrl,
					  type: APIBannerType(rawValue: model.bannerType) ?? .product,
					  productID: model.productId,
					  categoryID: model.categoryId,
					  subCategoryId: model.subCategoryId);
	}
}

class APIHomeDataToAppGlobalDataAdapter: TypeAdapter {
	// APIHomeData -> AppGlobalData
	func convert(from model: APIHomeData) -> AppGlobalData {
		let adapterUserType = Adapter(typeAdapter: APIUserTypeToUserTypeAdapter());
		
		return AppGlobalData(mustUpdateApp: Util.checkIfAppMustUpdate(newVersion: model.minRequiredVersion),
							 appSettings: AppSettings(hotLine: model.hotLine,
													  minimumOrderValue: model.minimumOrder,
													  shippingCost: model.shippingExpenses.shippingValue,
													  freeShippingMinimumOrderValue: model.shippingExpenses.maximumOrderValueFreeShipping,
													  serviceFees: model.serviceFee,
													  userWallet: model.wallet),
							 userInfo: AppGlobalData.UserInfo(name: model.displayName ?? "", email: model.email ?? "",
																						   userType: adapterUserType.convert(from: APIUserType(rawValue: model.userType)!)),
							 cartCount: model.cartProductCount);
	}
}
