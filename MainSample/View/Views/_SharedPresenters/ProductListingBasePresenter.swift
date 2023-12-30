//
//  ProductListingBasePresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 09/08/2023.
//

import Foundation

// TODO: This can be transformed into a generic ListingBasePresenter to be used by any paged listing views
@MainActor
class ProductListingBasePresenter: ProductBasePresenter {
	
	// MARK: - Dependencies

	
	// MARK: - Data
	@Published var items: [Product] = []
	
	// TODO: Should `totalCount` and `totalPages` be added to `ListParameters`?
	var totalCount: Int = 0
	var totalPages: Int = 0
	@Published var listParameters: ProductsListParameters = ProductsListParameters(pageSize: GlobalConstants.defaultPageSize,
																				   page: 1,
																				   merchantID: "",
																				   name: "",
																				   barCode: "",
																				   storeID: 0);
	
	// MARK: - View Presentation
	@Published var contentStatus: ListContentStatus = .initView
	@Published var loadingPhase: ViewDataLoadingPhase = .initLoad
	
	// MARK: - Init

	
	// MARK: - View Operations
	func resetData() {
		items = [];
		totalCount = 0;
		totalPages = 0;
	}
	
	func loadData(for loadingPhase: ViewDataLoadingPhase) {
		//- Error Handling: No connection - Prefetch check
		guard connection.isConnected else {
			triggerAlert(title: ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
						 message: "\(ErrorType.noConnection.localizedMessage) \(ErrorType.noConnection.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))",
						 actionButtonText: Localizables.retry.text) { [weak self] in
				
				self?.loadData(for: loadingPhase);
			}
			return;
		}
		
		self.loadingPhase = loadingPhase;
		
		// Call suitable methods for loadingPhase
		switch loadingPhase {
			case .initLoad:
				contentStatus = .initList;
				resetData();
				loadData();
				
			case .pagination:
				loadData();
				
			case .reload:
				resetData();
				loadData();
		}
	}
	
	// TODO: Remove `loadNextPage()` from other similar implementations, `loadInitData()` (must be `loadData()`) is enough
	override func loadData() {
		Task {
			// Fetch
			let result = await fetchData();
			
			// There is an active fetch
			guard let result = result else { return }
			
			// Failure
			guard result.succeeded else {
				handleFailedResult(result) { [weak self] in
					guard let self = self else { return }
					self.loadData(for: self.loadingPhase);
				}
				
				return;
			}
			
			// Success
			contentStatus = items.count > 0 ? .fullList : .emptyList;
		}
	}
	
	func setFavorite(itemIndex: Int, productID: Int, isFavorite: Bool) {
		// SampleSimplification:: 
//		super.setFavorite(productID: productID, isFavorite: isFavorite) { [weak self] in
//			self?.items[itemIndex].isFavorite = isFavorite;
//		}
	}
	
	// MARK: - Data Functions
	// Override to use any other data sources
	override func fetchData() async -> OperationResult? {
		// Don't fetch if there is an active fetching
		guard !isFetching else {
			return nil;
		}
		
		// Prepare paging parameters
		if (items.count > 0) {
			listParameters.page += 1;
		}
		
		// Fetch data
		startFetching();
		do {
			let data = try await interactor.getProducts(listParameters: listParameters);
			items.append(contentsOf: data.list);
			totalCount = data.totalCount;
			totalPages = data.totalPages;
			
			endFetching();
			
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			endFetching();
			if (listParameters.page > 1) { listParameters.page -= 1 }
			return OperationResult(succeeded: false, message: error.message, errorType: error.type);
		}
		catch {
			endFetching();
			if (listParameters.page > 1) { listParameters.page -= 1 }
			return OperationResult(succeeded: false, errorType: .unknownError);
		}
	}
	
}
