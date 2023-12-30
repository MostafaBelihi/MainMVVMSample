//
//  MerchantProductsPresenter.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 03/04/2023.
//

import Foundation

@MainActor
class MerchantProductsPresenter: ProductListingBasePresenter {

	// MARK: - Dependencies
	@Inject var merchantInteractor: PMerchantBusiness
	
	// MARK: - Data
	@Published var item: Merchant!
	@Published var categories: [Category] = []

	// MARK: - View Presentation
	@Published var selectedCategory: Category?		// if nil, `offers` are viewed
	@Published var merchantListParameters: ListParameters = ListParameters(pageSize: GlobalConstants.defaultPageSize, page: 1)
	
	var imageURL: String? { item.imageURL }
	
	var name: String { item.name }
	
	var supportedShopTypes: String? {
		// SampleSimplification:: 
		return "Dummy Data!!!";
	}
	
	var address: String? {
		// SampleSimplification:: 
		return "Dummy Data!!!";
	}
	
	var deliveryCost: String? {
		// SampleSimplification:: 
		return "Dummy Data!!!";
	}

	var shippingMethod: String? {
		// SampleSimplification:: 
		return "Dummy Data!!!";
	}
	
	var deliveryDuration: String? {
		// SampleSimplification:: 
		return "Dummy Data!!!";
	}
	
	// SampleSimplification:: 
	var selectedCategoryName: String { return "Dummy Data!!!" }

	// MARK: - Init
	func config(merchant: Merchant) {
		self.item = merchant;
		listParameters = ProductsListParameters(pageSize: GlobalConstants.defaultPageSize,
												page: 1,
												userID: auth.userID,
												merchantID: merchant.id,
												name: "",
												barCode: "",
												storeID: storeInteractor.getActiveStore().id);
	}
	
	// MARK: - View Operations
	func changeSelectedCategory(to newItem: Category?) {
		self.selectedCategory = newItem;
		listParameters.categoryID = newItem?.id;
	}
	
	override func resetData() {
		super.resetData();
		
		listParameters.page = 1;
		listParameters.userID = auth.userID;
		listParameters.storeID = storeInteractor.getActiveStore().id;
	}
	
	/// Use `loadData(for loadingPhase: ViewDataLoadingPhase)` in the super class, not this method.
	/// This is just an override of the super method to change data fetching source.
	override func loadData() {
		Task {
			// Fetch
			let result = selectedCategory == nil ? await fetchMerchantData() : await fetchData();
			
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

	// MARK: - Data Functions
	func fetchMerchantData() async -> OperationResult? {
		// Don't fetch if there is an active fetching
		guard !isFetching else {
			return nil;
		}
		
		// Prepare paging parameters
		if (items.count > 0) {
			merchantListParameters.page += 1;
		}
		
		// Fetch data
		startFetching();
		do {
			let data = try await merchantInteractor.getMerchantDetails(pageSize: merchantListParameters.pageSize,
																	   pageNo: merchantListParameters.page,
																	   id: item.id);

			item = data.details;
			categories = data.categories;
			// SampleSimplification:: 
//			items.append(contentsOf: data.offers.list);
//			totalCount = data.offers.totalCount;
//			totalPages = data.offers.totalPages;

			endFetching();
			
			return OperationResult(succeeded: true);
		}
		catch let error as AppError {
			endFetching();
			if (merchantListParameters.page > 1) { merchantListParameters.page -= 1 }
			return OperationResult(succeeded: false, message: error.message, errorType: error.type);
		}
		catch {
			endFetching();
			if (merchantListParameters.page > 1) { merchantListParameters.page -= 1 }
			return OperationResult(succeeded: false, errorType: .unknownError);
		}
	}

}
