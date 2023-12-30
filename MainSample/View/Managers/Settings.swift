//
//  Settings.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/05/2023.
//

import Foundation

@MainActor
class Settings: BasePresenter {
	
	// MARK: - Dependencies
	@Inject private var interactor: PHomeBusiness
	
	// MARK: - Data
	@Published var appSettings: AppSettings?
	
	// MARK: - Init Settings
	private var initTries = 0;
	private let maxInitTries = 10;
	
	func initSettings(_ appSettings: AppSettings? = nil) {
		self.appSettings = appSettings;
		
		if (self.appSettings == nil) {
			Task(priority: .medium) {
				await fetchInitSettings();
			}
		}
	}

	/// Inits settings data. Retries until successful resopnse achieved.
	private func fetchInitSettings() async {
		var result: OperationResult?
		
		// Retry if failed
		while ((result == nil || !(result?.succeeded ?? false)) && initTries < maxInitTries) {
			initTries += 1;
			result = await fetchData();
		}
	}

	// MARK: - Data Functions
	override func fetchData() async -> OperationResult? {
		// Don't fetch if there is an active fetching
		guard !isFetching else {
			return nil;
		}
		
		// Fetch data
		startFetching();
		do {
			let appGlobalData = try await interactor.getAppGlobalData();
			appSettings = appGlobalData.appSettings;
			endFetching();
			return OperationResult(succeeded: true);
		}
		catch {
			endFetching();
			return OperationResult(succeeded: false);
		}
	}

}
