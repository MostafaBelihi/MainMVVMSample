//
//  UserAuthInteractor.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

class UserAuthInteractor: PUserAuthBusiness {
	
	// MARK: - Dependencies
	@Inject private var data: PDataRequests
	@Inject private var auth: PAuthenticationManager
	@Inject private var notificationManager: PNotificationManager
	
	// MARK: - Data
	
	
	// MARK: - Init
	
	
	// MARK: - Functions
	/// Returns true if auth is success.
	func login(username: String, password: String) async throws -> Bool {
		// Authenticate with API
		var userAuth = try await data.login(username: username, password: password);
		
		// Get user's basic data
		let appData = try await data.getAppGlobalData(userID: userAuth.userID);
		
		userAuth.name = appData.userInfo?.name;
		userAuth.email = appData.userInfo?.email;
		userAuth.userType = appData.userInfo?.userType;
		
		// Authenticate the app
		_ = auth.setUserAuthentication(token: userAuth.token,
									   tokenExpiry: userAuth.expires,
									   userID: userAuth.userID,
									   name: userAuth.name ?? "",
									   username: userAuth.email ?? userAuth.userID,
									   userEmail: userAuth.email,
									   userType: userAuth.userType);
		
		// Register user with notifications
		await notificationManager.registerDeviceToken();

		return true;
	}
	
}
