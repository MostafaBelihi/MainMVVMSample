//
//  StoresDBData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 20/03/2023.
//

import Foundation

protocol PStoresDBData {
	func saveActiveStore(item: APIStore)
	func loadActiveStore() -> APIStore?
}

class StoresDBData: PStoresDBData {
	
	// MARK: - Dependencies
	@Inject private var defaultsData: PSimpleDataPersistence

	// MARK: - Init

	
	// MARK: - Functions
	func saveActiveStore(item: APIStore) {
		return defaultsData.store(item, usingKey: DBKeys.activeStore.rawValue);
	}

	func loadActiveStore() -> APIStore? {
		return defaultsData.retrieve(usingKey: DBKeys.activeStore.rawValue) as APIStore?;
	}

}
