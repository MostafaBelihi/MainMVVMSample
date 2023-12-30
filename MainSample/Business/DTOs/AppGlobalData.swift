//
//  AppGlobalData.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/03/2023.
//

import Foundation

struct AppGlobalData {
	var mustUpdateApp: Bool = false
	
	// Global Settings
	var appSettings: AppSettings

	// User data
	var userInfo: UserInfo?
	var cartCount: Int?
	
	struct UserInfo {
		var name: String
		var email: String
		var userType: UserType
	}
}
