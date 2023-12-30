//
//  HomeInteractor.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/03/2023.
//

import Foundation

class HomeInteractor: PHomeBusiness {
	
	// MARK: - Dependencies
	@Inject private var data: PDataRequests
	@Inject private var auth: PAuthenticationManager

	// MARK: - Functions
	func getAppGlobalData() async throws -> AppGlobalData {
		// Fetch
		let appData = try await data.getAppGlobalData(userID: auth.userID);
		
		// Save App Settings
		data.saveAppSettings(items: appData.appSettings);
		
		return appData;
	}

	func loadAppSettings() -> AppSettings? {
		return data.loadAppSettings();
	}

	func getHomeBanners() async throws -> [Banner] {
		return try await data.getHomeBanners();
	}

}
