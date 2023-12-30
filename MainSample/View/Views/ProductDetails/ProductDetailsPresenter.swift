//
//  ProductDetailsPresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 13/04/2023.
//

import Foundation

@MainActor
class ProductDetailsPresenter: ProductItemPresenter {
	
	// MARK: - Dependencies

	
	// MARK: - Data
	var productID: Int!
	var merchantID: String!
	var subCategoryID: Int!
	
	// MARK: - View Presentation

	// MARK: - Quantity Handling
	var sellableQuantity: Int { item?.sellableQuantity ?? 0 }
	
	@Published var quantity: Int = 1
	
	var quantityText: String {
		"\(quantity)"
	}

	/// Quantity already added for this product in the Cart.
	var quantityInCart: Int {
		guard let item = item else {
			return 0;
		}
		
		// SampleSimplification:: 
//		return cart.getQuantityAlreadyInCart(productID: item.id);
		return 0;
	}

	/// `availableQauntity` is the diff between sellable quantity and quantity the user added to the Cart.
	var availableQuantity: Int {
		return sellableQuantity - quantityInCart;
	}
	
	// Quantity Operations
	func incrementQuantity() {
		quantity += 1
		let result = validateQuantity();
		handleQuantityResult(result);
	}
	
	func decrementQuantity() {
		quantity -= 1;
		let result = validateQuantity();
		handleQuantityResult(result);
	}
	
	// TODO: I may centralize validating sellable quantity to the Cart class
	/// Returns false if exceeds maximum allowed quantity, nil otherwise.
	func validateQuantity() -> Bool? {
		if (quantity < 1) {
			quantity = 1;
		}

		// Compare to `sellableQuantity`.
		if (quantity > sellableQuantity) {
			quantity = sellableQuantity <= 0 ? 1 : sellableQuantity;
			return false;
		}
		
		return nil;
	}

	private func handleQuantityResult(_ result: Bool?) {
		if let result = result, result == false {
			let sellableQuantityText = Localizables.generatePiecesText(Double(sellableQuantity));
			triggerAlert(title: Localizables.exceededMaxQuantityTitle.text,
						 message: Localizables.exceededMaxQuantity.text.replacingOccurrences(of: "{0}", with: "\(sellableQuantityText)"));
		}
	}

	// MARK: - Init
	func config(productID: Int, product: Product?, merchantID: String, subCategoryID: Int) {
		self.productID = productID;
		self.item = product;
		self.merchantID = merchantID;
		self.subCategoryID = subCategoryID;
		self.quantity = (quantityInCart == 0) ? 1 : quantityInCart;
	}
	
	// MARK: - View Operations
	override func loadData() {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: ErrorType.noConnection.localizedMessage);
			return;
		}
		
		Task {
			// Fetch
			let result = await fetchData();
			
			// There is an active submit
			guard let result = result else { return }
			
			// Failure
			guard result.succeeded else {
				handleFailedResult(result);
				return;
			}
		}
	}

	func setFavorite(productID: Int, isFavorite: Bool) {
		// SampleSimplification:: 
//		super.setFavorite(productID: productID, isFavorite: isFavorite) { [weak self] in
//			self?.isFavorite = isFavorite;
//		}
	}

	// MARK: - Data Functions
	override func fetchData() async -> OperationResult? {
		// Don't fetch if there is an active fetching
		guard !isFetching else {
			return nil;
		}
		
		// Fetch data
		startFetching();
		do {
			item = try await interactor.getProductDetails(id: productID,
														  storeID: storeInteractor.getActiveStore().id,
														  merchantID: merchantID,
														  userID: auth.userID,
														  subCategoryID: subCategoryID);
			endFetching();
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			endFetching();
			// TODO: Use direct return like this in other similar methods instead of using a variable first
			return OperationResult(succeeded: false, message: error.message, errorType: error.type);
		}
		catch {
			return OperationResult(succeeded: false, errorType: .unknownError);
		}
	}

}
