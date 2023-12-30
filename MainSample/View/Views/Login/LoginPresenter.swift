//
//  LoginPresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/02/2023.
//

import Foundation

@MainActor
class LoginPresenter: BasePresenter {

	// MARK: - Dependencies
	@Inject private var interactor: PUserAuthBusiness

	// MARK: - Data
	@Published var username: String = ""
	@Published var password: String = ""

	// MARK: - Init

	
	// MARK: - View Operations
	override func handleFailedResult(_ result: OperationResult?, actionBlock: VoidClosure? = nil) {
		if let result = result {
			//- Error Handling: Unauth - If service response is 401 or 403
			if (result.errorType == .unauthorizedUser) {
				triggerAlert(title: Localizables.failTitle.text,
							 message: Localizables.failedLogin.text);
				return;
			}
		}
		
		super.handleFailedResult(result, actionBlock: actionBlock);
	}
	
	// MARK: - Data Functions
	override func postData() async -> OperationResult? {
		// Don't submit if there is an active submit
		guard !isSubmitting else {
			return nil;
		}

		// Fetch data
		startSubmitting();
		do {
			_ = try await interactor.login(username: username, password: password);
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
