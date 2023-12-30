//
//  GeneralDBData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/05/2023.
//

import Foundation

protocol PGeneralDBData {
	func saveAppSettings(items: AppSettings)
	func loadAppSettings() -> AppSettings?
}

class GeneralDBData: PGeneralDBData {
	
	// MARK: - Dependencies
	@Inject private var defaultsData: PSimpleDataPersistence

	// MARK: - Functions
	func saveAppSettings(items: AppSettings) {
		defaultsData.store(items, usingKey: DBKeys.appSettings.rawValue);
	}
	
	func loadAppSettings() -> AppSettings? {
		return defaultsData.retrieve(usingKey: DBKeys.appSettings.rawValue) as AppSettings?;
	}

}
