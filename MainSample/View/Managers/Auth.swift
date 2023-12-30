//
//  Auth.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/03/2023.
//

import Foundation

@MainActor
class Auth: BasePresenter {
	
	// MARK: - Dependencies
	@Inject private var auth: PAuthenticationManager
	
	// MARK: - Data
	@Published var isAuthenticated: Bool = false
	@Published var userID: String?
	@Published var name: String?
	@Published var userEmail: String?
	@Published var userType: UserType?
	
	// MARK: - Init
	init() {
		super.init();
		
		refreshAuthData();
	}
	
	// MARK: - Data Functions
	func refreshAuthData() {
		isAuthenticated = auth.isUserAuthenticated;
		userID = auth.userID;
		name = auth.name;
		userEmail = auth.userEmail;
		userType = auth.userType;
	}

	func logoutUser() {
		isAuthenticated = false;
		userID = nil;
		name = nil;
		userEmail = nil;
		userType = nil;
	}

}
