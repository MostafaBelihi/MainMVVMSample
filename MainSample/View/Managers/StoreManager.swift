//
//  StoreManager.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 21/03/2023.
//

import Foundation

@MainActor
class StoreManager: BasePresenter {
	
	// MARK: - Dependencies
	@Inject private var interactor: PStoreBusiness
	
	// MARK: - Data
	@Published var activeStore: Store!
	@Published var stores: [Store]?
	
	// MARK: - Init
	init() {
		super.init();
		
		initStoresData();
	}

	// MARK: - Data Functions
	func initStoresData() {
		activeStore = interactor.getActiveStore();
		
		Task(priority: .medium) {
			do {
				stores = try await interactor.loadStores();
			}
			catch {
				return;
			}
		}
	}
	
	func loadStores() async -> OperationResult? {
		if stores == nil {
			// Don't fetch if there is an active submit
			guard !isFetching else {
				return nil;
			}
			
			// Fetch data
			startFetching();
			do {
				stores = try await interactor.loadStores();
				endFetching();
				
				guard stores!.count > 0 else {
					stores = nil;
					return OperationResult(succeeded: false);
				}
				
				return OperationResult(succeeded: true);
			}
			catch {
				endFetching();
				stores = nil;
				return OperationResult(succeeded: false);
			}
		}

		return OperationResult(succeeded: true);
	}
	
	func changeActiveStore(_ store: Store) {
		interactor.setActiveStore(store);
		activeStore = store;
	}

}

extension Store {
	var uniqueID: UUID { UUID() }
}
