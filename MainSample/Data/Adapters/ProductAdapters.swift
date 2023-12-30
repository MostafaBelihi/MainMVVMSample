//
//  ProductAdapters.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/03/2023.
//

import Foundation

class ProductsListParametersToAPIProductsListRequestAdapter: TypeAdapter {
	// ProductsListParameters -> APIProductsListRequest
	func convert(from model: ProductsListParameters) -> APIProductsListRequest {
		return APIProductsListRequest(pageSize: model.pageSize,
									  pageNo: model.page,
									  customerId: model.userID,
									  merchantId: model.merchantID ?? "",
									  categoryId: model.categoryID,
									  storeId: model.storeID);
	}
}

class APIProductToProductAdapter: TypeAdapter {
	// APIProduct -> Product
	func convert(from model: APIProduct) -> Product {
		return Product(id: model.id,
					   name: model.name,
					   sellerID: model.merchantId,
					   sellerName: model.shopName,
					   sku: model.sku,
					   subCategoryID: model.subCategoryId,
					   price: model.priceAfterDiscount > 0 ? model.priceAfterDiscount : model.price,
					   originalPrice: (model.priceAfterDiscount > 0 && model.priceAfterDiscount != model.price) ? model.price : nil,
					   imageURL: model.image,
					   isAvailable: model.isAvailable,
					   sellableQuantity: Int(model.salableQuantity)
		);
	}
}
