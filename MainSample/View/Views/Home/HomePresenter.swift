//
//  Homeswift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 01/03/2023.
//

import Foundation

@MainActor
class HomePresenter: BasePresenter {

	// MARK: - Dependencies
	@Inject private var homeInteractor: PHomeBusiness
	@Inject private var merchantInteractor: PMerchantBusiness
	@Inject private var auth: PAuthenticationManager
	
	// This cannot be injected using normal `@Inject` because it's not initialized in `TabBarView` at the time this class is present
	var settings: Settings?

	// MARK: - Data
	@Published var banners: [Banner] = []
	@Published var recommendedMerchants: [Merchant] = []
	@Published var topMerchantProducts: [HomeMerchantProductsDTO] = []
	
	@Published var mustUpdateApp: Bool = false

	// MARK: - View Presentation
	@Published var searchQuery: String = ""
	@Published var searchBarCode: String = ""

	// MARK: - Init
	func config(settings: Settings) {
		self.settings = settings;
	}
	
	// MARK: - App Pre-Load
	enum AppPreLoadStatus {
		case notStarted
		case inProgress
		case succeeded
		case failed
		case done
	}
	
	var appPreLoadStatus: AppPreLoadStatus = .notStarted
	@Published var appPreLoadResult: OperationResult?

	// The following functions update AppPreloadStatus with different data fetch events, however this applies only if no prior pre-load done
	// Update AppPreLoadStatus
	private func startedDataFetch() {
		// If AppPreLoadStatus has any other status, this means it has already done before
		if (appPreLoadStatus == .notStarted) {
			appPreLoadStatus = .inProgress;
		}
	}

	func preloadHomeData() {
		Task {
			async let _ = fetchHomeData();
			async let _ = fetchHomeBanners();
			async let _ = fetchRecommendedMerchants();
			async let _ = fetchTopMerchantProducts();
		}
	}

	// Update AppPreLoadStatus
	private func succeededDataFetch() {
		print("(\(Date.now)) Status:: Called succeeded")
		// Don't apply success if there was a previous failure of if pre-load is finished
		if (appPreLoadStatus != .failed && appPreLoadStatus != .done) {
			appPreLoadStatus = .succeeded;
			print("(\(Date.now)) Status:: Set succeeded")
		}
	}

	// Update AppPreLoadStatus
	private func failedDataFetch(with result: OperationResult) {
		print("(\(Date.now)) Status:: Called failed")
		// Don't apply failure if pre-load is finished
		appPreLoadStatus = .failed;
		print("(\(Date.now)) Status:: Set failed")

		// If there is an older result, do not overwrite it
		if (appPreLoadResult == nil) {
			appPreLoadResult = result;
		}
	}
	
	// AppPreLoad is finished, this means it won't be fired again
	private func finishAppPreLoad() {
		print("(\(Date.now)) Status:: Called finish")
		appPreLoadStatus = .done;
		print("(\(Date.now)) Status:: Set done")
	}

	// MARK: - View Operations
	override func loadData() {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: "\(ErrorType.noConnection.localizedMessage) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))",
						 actionButtonText: Localizables.retry.text) { [weak self] in
				
				self?.loadData();
			}
			return;
		}
		
		Task {
			// Fetch
			async let homeResult = fetchHomeData();
			async let bannersResult = fetchHomeBanners();
			async let recommendedMerchantsResult = fetchRecommendedMerchants();
			async let topMerchantProductsResult = fetchTopMerchantProducts();
			
			// Catch result
			let results = await [homeResult, bannersResult, recommendedMerchantsResult, topMerchantProductsResult];
			let fetchesSucceeded = results.reduce(true) { $0 && $1?.succeeded ?? true }
			
			// Failure
			guard fetchesSucceeded else {
				let firstFailedResult = results.first(where: {
					guard let result = $0 else {
						return false;
					}
					
					return result.succeeded == false;
				});
				
				settings?.initSettings();	// retry loading settings in case initial fetching of home data failed
				handleFailedResult(firstFailedResult as? OperationResult) { [weak self] in
					self?.loadData();
				}
				
				return;
			}
		}
	}

	func reloadData() {
		// Reset
		recommendedMerchants = [];
		topMerchantProducts = [];
		
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: "\(ErrorType.noConnection.localizedMessage) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))",
						 actionButtonText: Localizables.retry.text) { [weak self] in
				
				self?.reloadData();
			}
			return;
		}
		
		Task {
			// Fetch
			async let recommendedMerchantsResult = fetchRecommendedMerchants();
			async let topMerchantProductsResult = fetchTopMerchantProducts();
			
			// Catch result
			let results = await [recommendedMerchantsResult, topMerchantProductsResult];
			let fetchesSucceeded = results.reduce(true) { $0 && $1?.succeeded ?? true }
			
			// Failure
			guard fetchesSucceeded else {
				let firstFailedResult = results.first(where: {
					guard let result = $0 else {
						return false;
					}
					
					return result.succeeded == false;
				});
				
				handleFailedResult(firstFailedResult as? OperationResult) { [weak self] in
					self?.reloadData();
				}
				
				return;
			}
		}
	}

	func handleAppPreLoad() {
		// If in progress, wait for results
		if (appPreLoadStatus == .inProgress) {
			return;
		}

		// Success
		if (appPreLoadStatus == .succeeded) {
			finishAppPreLoad();
		}

		// Failure
		if (appPreLoadStatus == .failed) {
			settings?.initSettings();	// retry loading settings in case initial fetching of home data failed
			handleFailedResult(appPreLoadResult) { [weak self] in
				guard let self = self else { return }
				self.loadData();
			}
		}
	}
	
	// MARK: - Data Functions
	private func fetchHomeData() async -> OperationResult? {
		do {
			startedDataFetch();
			
			let homeData = try await homeInteractor.getAppGlobalData();
			
			mustUpdateApp = homeData.mustUpdateApp;
			settings?.initSettings(homeData.appSettings);
			
			succeededDataFetch();
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			let result = OperationResult(succeeded: false, message: error.message, errorType: error.type);
			failedDataFetch(with: result);
			return result;
		}
		catch {
			let result = OperationResult(succeeded: false, errorType: .unknownError);
			failedDataFetch(with: result);
			return result;
		}
	}

	private func fetchHomeBanners() async -> OperationResult? {
		do {
			startedDataFetch();
			banners = try await homeInteractor.getHomeBanners();
			
			succeededDataFetch();
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			let result = OperationResult(succeeded: false, message: error.message, errorType: error.type);
			failedDataFetch(with: result);
			return result;
		}
		catch {
			let result = OperationResult(succeeded: false, errorType: .unknownError);
			failedDataFetch(with: result);
			return result;
		}
	}

	private func fetchRecommendedMerchants() async -> OperationResult? {
		// Fetch data
		startFetching();
		do {
			startedDataFetch();
			recommendedMerchants = try await merchantInteractor.getRecommendedMerchants();
			
			succeededDataFetch();
			endFetching();
			
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			endFetching();
			let result = OperationResult(succeeded: false, message: error.message, errorType: error.type);
			failedDataFetch(with: result);
			return result;
		}
		catch {
			endFetching();
			let result = OperationResult(succeeded: false, errorType: .unknownError);
			failedDataFetch(with: result);
			return result;
		}
	}

	private func fetchTopMerchantProducts() async -> OperationResult? {
		// Fetch data
		startFetching();
		do {
			startedDataFetch();
			topMerchantProducts = try await merchantInteractor.getTopMerchantsProducts();
			
			succeededDataFetch();
			endFetching();
			
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			endFetching();
			let result = OperationResult(succeeded: false, message: error.message, errorType: error.type);
			failedDataFetch(with: result);
			return result;
		}
		catch {
			endFetching();
			let result = OperationResult(succeeded: false, errorType: .unknownError);
			failedDataFetch(with: result);
			return result;
		}
	}

}
