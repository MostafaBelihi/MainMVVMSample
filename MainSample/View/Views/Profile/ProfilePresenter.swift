//
//  ProfilePresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 19/04/2023.
//

import Foundation

@MainActor
class ProfilePresenter: BasePresenter {

	// MARK: - Dependencies
	@Inject var interactor: PUserAuthBusiness
	@Inject var auth: PAuthenticationManager
	@Inject private var settings: Settings

	// MARK: - View Presentation
	var hotLine: String {
		guard let appSettings = settings.appSettings else {
			triggerAlert(title: Localizables.failTitle.text,
						 message: ErrorType.internalError.localizedMessage);
			return "";
		}
		
		return appSettings.hotLine;
	}
	
	// MARK: - Init


	// MARK: - View Operations
	func logout(successCompletion: @escaping VoidClosure) {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			// TODO: This message is used in many places. I may add it to a function in BasePresenter to make changing it easier.
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: ErrorType.noConnection.localizedMessage);
			return;
		}
		
		Task {
			// Fetch
			let result = await logoutUser();
			
			// There is an active fetch
			guard let result = result else { return }
			
			// Failure
			guard result.succeeded else {
				handleFailedResult(result);
				return;
			}
			
			// Success, proceed
			successCompletion();
		}
	}

	func deleteUser(successCompletion: @escaping VoidClosure) {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			// TODO: This message is used in many places. I may add it to a function in BasePresenter to make changing it easier.
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: ErrorType.noConnection.localizedMessage);
			return;
		}
		
		Task {
			// Fetch
			let result = await deleteUser();
			
			// There is an active fetch
			guard let result = result else { return }
			
			// Failure
			guard result.succeeded else {
				handleFailedResult(result);
				return;
			}
			
			// Success, proceed
			successCompletion();
		}
	}

	// MARK: - Data Functions
	// TODO: I may move this and all user auth functions to the `Auth` class as its presenter. This happens with `Cart` and `Stores` classes. This way, I don't need to complete post-actions of this class in the view.
	private func logoutUser() async -> OperationResult? {
		// Don't submit if there is an active submit
		guard !isSubmitting else {
			return nil;
		}
		
		// Fetch data
		startSubmitting();
		do {
			// SampleSimplification:: 
//			_ = try await interactor.logout();
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

	// TODO: I may move this and all user auth functions to the `Auth` class as its presenter. This happens with `Cart` and `Stores` classes. This way, I don't need to complete post-actions of this class in the view.
	private func deleteUser() async -> OperationResult? {
		// Don't submit if there is an active submit
		guard !isSubmitting else {
			return nil;
		}
		
		// Fetch data
		startSubmitting();
		do {
			// SampleSimplification:: 
//			_ = try await interactor.deleteUser();
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
