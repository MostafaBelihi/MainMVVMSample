//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

@MainActor
class BasePresenter: ObservableObject {

	// MARK: - Dependencies
	@Inject var connection: Connectivity

	// MARK: - View Flags
	@Published var triggeredAlert = false
	var alertInfo = Alert()
	
	// MARK: - Data Flags
	@Published var isReloading = false;
	@Published var isPaging = false;

	// TODO: I may handle these flags using an enum or some. This can be like the `ViewDataLoadingPhase` used in `ProductsListView`. It's better to be centralized here building on this implementation.
	@Published var isFetching = false;
	@Published var isFetchingPaging = false;
	@Published var isFetchingReloading = false;
	@Published var isSubmitting = false;

	@Published var fetchCount: Int = 1;
	@Published var fetchedCount: Int = 0;
	
	var didFinishFetching: Bool {
		return fetchedCount >= fetchCount;
	}

	// MARK: - Init
	init(fetchCount: Int = 1) {
		self.fetchCount = fetchCount;
	}

	// MARK: - Data Flags Functions
	func startReloading() {
		isReloading = true;
	}

	func startPaging() {
		isPaging = true;
	}

	func endPaging() {
		isPaging = false;
	}

	func startFetching() {
		isFetching = !isReloading && !isPaging;
		isFetchingPaging = !isReloading && isPaging;
		isFetchingReloading = isReloading && !isPaging;
	}

	func endFetching() {
		isReloading = false;
		isFetching = false;
		isFetchingPaging = false;
		isFetchingReloading = false;
	}
	
	func startSubmitting() {
		isSubmitting = true;
	}
	
	func endSubmitting() {
		isSubmitting = false;
	}
	
	// MARK: - View Operations
	func loadData() {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: ErrorType.noConnection.localizedMessage);
			return;
		}
		
		Task {
			// Fetch
			let result = await fetchData();
			
			// There is an active fetch
			guard let result = result else { return }
			
			// Failure
			guard result.succeeded else {
				handleFailedResult(result) { [weak self] in
					self?.loadData();
				}

				return;
			}
		}
	}

	func submit(successCompletion: VoidClosure? = nil) {
		//- Error Handling: No connection - Pre-check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: "\(ErrorType.noConnection.localizedMessage) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))");
			return;
		}

		Task {
			// Submit
			let result = await postData();
			
			// There is an active submit
			guard let result = result else { return }
			
			//- Error Handling
			guard result.succeeded else {
				handleFailedResult(result);
				return;
			}
			
			// Success, proceed
			successCompletion?();
		}
	}

	// MARK: - Data Functions
	func fetchData() async -> OperationResult? {
		fatalError("Override this method!");
	}

	func postData() async -> OperationResult? {
		fatalError("Override this method!");
	}

	// MARK: - Network Callbacks
	func succeedFetching(newIndexes: [Int]? = nil, alwaysCallback: VoidClosure = {}, completionCallback: VoidClosure = {}) {
		succeedNetworkCall(newIndexes: newIndexes, alwaysCallback: alwaysCallback) {
			completionCallback();
		}
	}
	
	func succeedSubmitting(alwaysCallback: VoidClosure = {}, completionCallback: VoidClosure = {}) {
		succeedNetworkCall(alwaysCallback: alwaysCallback) {
			completionCallback();
		}
	}
	
	private func succeedNetworkCall(newIndexes: [Int]? = nil, alwaysCallback: VoidClosure = {}, completionCallback: VoidClosure = {}) {
		guard fetchedCount >= 0 else {
			return;
		}
		
		fetchedCount += 1;
		
		alwaysCallback();
		
		if (fetchedCount >= fetchCount) {
			endFetching();
			completionCallback();
		}
	}

	func failNetworkCall(error: AppError, callback: VoidClosure = {}) {
		fetchedCount = 0;
		endFetching();
		callback();
	}
	
	// MARK: - Alerts
	/// Configs `alertInfo` using provided alert parameters then triggers it to be shown within a View that obeserves `triggeredAlert`.
	func triggerAlert(title: String, message: String, actionButtonText: String? = nil, actionButtonHandler: VoidClosure? = nil) {
		alertInfo = Alert(title: title, message: message, actionButtonText: actionButtonText, actionButtonHandler: actionButtonHandler);
		triggeredAlert.toggle();
	}
	
	// MARK: - Handling Failures
	func handleFailedResult(_ result: OperationResult?, actionBlock: VoidClosure? = nil) {
		//- Error Handling: No result
		guard let result = result else {
			var message = ErrorType.noConnection.localizedMessage;
			message = actionBlock == nil ? message : "\(message) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))";
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: message,
						 actionButtonText: actionBlock == nil ? nil : Localizables.retry.text,
						 actionButtonHandler: actionBlock);
			return;
		}
		
		//- Error Handling: Unauth - If service response is 401 or 403
		if (result.errorType == .unauthorizedUser) {
			triggerAlert(title: Localizables.failTitle.text,
						 message: Localizables.unauthFailure.text);
			return;
		}
		
		//- Error Handling: No connection - If causes a service failure
		if (!connection.isConnected) {
			var message = ErrorType.noConnection.localizedMessage;
			message = actionBlock == nil ? message : "\(message) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))";
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: message,
						 actionButtonText: actionBlock == nil ? nil : Localizables.retry.text,
						 actionButtonHandler: actionBlock);
			return;
		}
		
		//- Error Handling: Handle custom message
		if let message = result.message {
			triggerAlert(title: Localizables.failTitle.text,
						 message: message);
			return;
		}
		
		//- Error Handling: Unknown Error
		guard let errorType = result.errorType else {
			var message = ErrorType.unknownError.localizedMessage;
			message = actionBlock == nil ? message : "\(message) \(ErrorType.unknownError.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))";
			triggerAlert(title: ErrorType.unknownError.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: message,
						 actionButtonText: actionBlock == nil ? nil : Localizables.retry.text,
						 actionButtonHandler: actionBlock);
			return;
		}
		
		//- Error Handling: Service error
		var message = errorType.localizedMessage;
		message = actionBlock == nil ? message : "\(message) \(errorType.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))";
		triggerAlert(title: errorType.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
					 message: message,
					 actionButtonText: actionBlock == nil ? nil : Localizables.retry.text,
					 actionButtonHandler: actionBlock);
		return;
	}

}

// MARK: - Embedded Types
extension BasePresenter {
	struct Alert {
		var title: String = ""
		var message: String = ""
		var actionButtonText: String?
		var actionButtonHandler: VoidClosure?
	}
}
