//
//  ProductBasePresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 31/08/2023.
//

import Foundation

@MainActor
class ProductBasePresenter: BasePresenter {
	
	// MARK: - Dependencies
	@Inject var interactor: PProductBusiness
	@Inject var auth: PAuthenticationManager
	@Inject var storeInteractor: PStoreBusiness
	// SampleSimplification:: 
//	@Inject var cart: Cart
	
	// MARK: - Data

	
	// MARK: - View Presentation

	
	// MARK: - Init

	
	// MARK: - View Operations
	func setFavorite(productID: Int, isFavorite: Bool, stateChangeCompltion: @escaping VoidClosure) {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: "\(ErrorType.noConnection.localizedMessage) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))");
			return;
		}
		
		//- Error Handling: No auth
		guard auth.isUserAuthenticated else {
			triggerAlert(title: ErrorType.unauthorizedUser.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: ErrorType.unauthorizedUser.localizedMessage);
			return;
		}

		Task {
			let result = await setFavorite(productID: productID, isFavorite: isFavorite);
			
			// Failure
			guard result.succeeded else {
				handleFailedResult(result);
				return;
			}
			
			// Success
			stateChangeCompltion();
		}
	}

	func addToCart(item: Product, quantity: Double? = nil) {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: "\(ErrorType.noConnection.localizedMessage) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))");
			return;
		}
		
		//- Error Handling: No auth
		guard auth.isUserAuthenticated else {
			triggerAlert(title: ErrorType.unauthorizedUser.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: ErrorType.unauthorizedUser.localizedMessage);
			return;
		}

		// SampleSimplification:: 
//		Task {
//			let result = await cart.update(newItem: item, quantity: quantity);
//			
//			// There is an active submit
//			guard let result = result else { return }
//			
//			// Failure
//			if (!result.succeeded) {
//				handleFailedResult(result);
//			}
//		}
	}
	
	// MARK: - Data Functions
	func setFavorite(productID: Int, isFavorite: Bool) async -> OperationResult {
		startSubmitting();
		do {
			// SampleSimplification:: 
//			let result = try await interactor.setProductFavorite(productID: productID, isFavorite: isFavorite);
//			
//			guard result else {
//				return OperationResult(succeeded: false, errorType: .serviceError);
//			}
			
			endSubmitting();
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			endSubmitting();
			return OperationResult(succeeded: false, message: error.message, errorType: error.type);
		}
		catch {
			endSubmitting();
			return OperationResult(succeeded: false, errorType: .unknownError);
		}
	}

}
