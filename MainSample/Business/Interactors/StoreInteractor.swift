//
//  StoreInteractor.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 20/03/2023.
//

import Foundation

class StoreInteractor: PStoreBusiness {
	
	// MARK: - Dependencies
	@Inject private var data: PDataRequests
	
	// MARK: - Data
	private var activeStore: Store?
	
	// MARK: - Init
	
	
	// MARK: - Functions
	/// Loads local Stores, or fetch remote ones if no local stored Stores.
	func loadStores() async throws -> [Store] {
		return try await data.fetchStores();
	}
	
	func setActiveStore(_ store: Store) {
		activeStore = store;
		data.saveActiveStore(store);
	}

	func getActiveStore() -> Store {
		return activeStore ?? data.loadActiveStore();
	}

}
