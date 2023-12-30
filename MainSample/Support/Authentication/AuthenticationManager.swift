//
//  AuthenticationManager.swift
//  HomeView
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation
import KeychainSwift

protocol PAuthenticationManager {
	var isUserAuthenticated: Bool { get }
	var userToken: String { get }
	var username: String? { get }
	var userID: String? { get }
	var name: String? { get }
	var userEmail: String? { get }
	var userType: UserType? { get }

	func setUserAuthentication(token: String, tokenExpiry: Date?, userID: String, name: String, username: String, userEmail: String?, userType: UserType?) -> Bool;
	func clearUserAuthentication();
}

// TODO: Improvements: Store whole objects instead of storing and retrieving individual properties
class AuthenticationManager: PAuthenticationManager {

	// MARK: - Dependencies
	private let keychain = KeychainSwift();
	private let defaults = UserDefaultsManager()

	// MARK: - Data
	private var userAuth: Auth?
	private var userInfo: UserAuthInfo?
	
	// Legacy auth data are handled to retain user's auth from older version, then use new secure data storage for new auth operations for the new version.
	private var legacyToken: String?
	
	// MARK: - More Variabless
	private var dateFormat = "dd/MM/yyyy HH:mm:ss";
	
	// MARK: - Init
	init(dateFormat: String? = nil) {
		if let dateFormat = dateFormat {
			self.dateFormat = dateFormat;
		}
	}
	
	// MARK: - Properties
	var isUserAuthenticated: Bool {
		var isAuthenticated = false;
		
		if userAuth == nil {
			userAuth = retriveAuthInfo();
		}
		
		if let userAuth = userAuth {
			if let tokenExpiry = userAuth.tokenExpiry {
				isAuthenticated = !userAuth.token.isEmpty && tokenExpiry > Date.now;
			}
			else {
				isAuthenticated = !userAuth.token.isEmpty;
			}
		}
		
		if (!isAuthenticated) {
			self.clearUserAuthentication();
		}
		
		return isAuthenticated;
	}
	
	var userToken: String {
		if userAuth == nil {
			userAuth = retriveAuthInfo();
		}
		
		if let userAuth = userAuth {
			return userAuth.token;
		}
		
		return "";
	}
	
	var username: String? {
		if userInfo == nil {
			userInfo = retrieveUserInfo();
		}
	
		if let userInfo = userInfo {
			return userInfo.username;
		}
		
		return nil;
	}
	
	var userID: String? {
		if userInfo == nil {
			userInfo = retrieveUserInfo();
		}
	
		if let userInfo = userInfo {
			return userInfo.userID;
		}
		
		return nil;
	}
	
	var name: String? {
		if userInfo == nil {
			userInfo = retrieveUserInfo();
		}
	
		if let userInfo = userInfo {
			return userInfo.name;
		}
		
		return nil;
	}
	
	var userEmail: String? {
		if userInfo == nil {
			userInfo = retrieveUserInfo();
		}
	
		if let userInfo = userInfo {
			return userInfo.email;
		}
		
		return nil;
	}
	
	var userType: UserType? {
		if userInfo == nil {
			userInfo = retrieveUserInfo();
		}
	
		if let userInfo = userInfo {
			return userInfo.userType;
		}
		
		return nil;
	}

	// MARK: - Functions
	// [deferred]TODO: Isolate Keychain store/retrieve logic in a dedicated class, like done with UserDefaults
	func setUserAuthentication(token: String, tokenExpiry: Date? = nil, userID: String, name: String, username: String, userEmail: String?, userType: UserType?) -> Bool {
		let successAuthInfo = storeAuthInfo(token: token, tokenExpiry: tokenExpiry);
		userAuth = Auth(token: token, tokenExpiry: tokenExpiry);
		
		let successUserInfo = storeUserInfo(userID: userID, name: name, username: username, userEmail: userEmail, userType: userType);
		userInfo = UserAuthInfo(userID: userID, name: name, username: username, email: userEmail, userType: userType);
		
		return successAuthInfo && successUserInfo;
	}
	
	func clearUserAuthentication() {
		_ = clearAuthInfo();
		userAuth = nil;
		
		_ = clearUserInfo();
		userInfo = nil;
	}
	
	// MARK: - Private Functions
	private func storeAuthInfo(token: String, tokenExpiry: Date? = nil) -> Bool {
		let successToken = keychain.set(token, forKey: AuthenticationKeys.userToken.rawValue);
		
		var successTokenExpiry = true;
		if let tokenExpiry = tokenExpiry {
			successTokenExpiry = successTokenExpiry && keychain.set(tokenExpiry.toString(format: dateFormat),
																	forKey: AuthenticationKeys.userTokenExpiry.rawValue);
		}
		
		return successToken && successTokenExpiry;
	}
	
	private func retriveAuthInfo() -> Auth? {
		// Check if legacy data retrived before
		if let legacyToken = legacyToken {
			return Auth(token: legacyToken);
		}
		else {
			// Check if legacy data are stored
			legacyToken = defaults.retrieve(usingKey: AuthenticationKeys.userToken.legacyName) as String?;

			if let legacyToken = legacyToken {
				return Auth(token: legacyToken);
			}
			else {
				// No legacy data, handle normal secure data
				let storedToken = keychain.get(AuthenticationKeys.userToken.rawValue);
				let storedTokenExpiryString = keychain.get(AuthenticationKeys.userTokenExpiry.rawValue);
				let storedTokenExpiry = Date.fromString(storedTokenExpiryString ?? "", format: dateFormat);
				
				guard let storedToken = storedToken else {
					return nil;
				}
				
				return Auth(token: storedToken, tokenExpiry: storedTokenExpiry);
			}
		}
	}
	
	private func clearAuthInfo() -> Bool {
		// Clear legacy data
		if (legacyToken != nil) {
			defaults.remove(usingKey: AuthenticationKeys.userToken.legacyName);
			legacyToken = nil;
		}
		
		// Clear normal data
		let successToken = keychain.delete(AuthenticationKeys.userToken.rawValue);
		let successTokenExpiry = keychain.delete(AuthenticationKeys.userTokenExpiry.rawValue);
		
		return successToken && successTokenExpiry;
	}
	
	private func storeUserInfo(userID: String, name: String, username: String, userEmail: String?, userType: UserType?) -> Bool {
		let successUserID = keychain.set(userID, forKey: AuthenticationKeys.userID.rawValue);
		let successName = keychain.set(name, forKey: AuthenticationKeys.name.rawValue);
		let successUsername = keychain.set(username, forKey: AuthenticationKeys.username.rawValue);
		
		var successUserEmail = true;
		if let userEmail = userEmail {
			successUserEmail = keychain.set(userEmail, forKey: AuthenticationKeys.userEmail.rawValue);
		}
		
		var successUserType = true;
		if let userType = userType {
			successUserType = keychain.set(userType == .customer ? false : true,
										   forKey: AuthenticationKeys.isMerchant.rawValue);
		}

		return successUserID && successName && successUsername && successUserEmail && successUserType;
	}
	
	private func retrieveUserInfo() -> UserAuthInfo? {
		// Check if legacy data retrieved before
		if legacyToken == nil {
			legacyToken = defaults.retrieve(usingKey: AuthenticationKeys.userToken.legacyName) as String?;
		}
		
		if legacyToken != nil {
			let storedUserID = defaults.retrieve(usingKey: AuthenticationKeys.userID.legacyName) as String?;
			let storedName = defaults.retrieve(usingKey: AuthenticationKeys.name.legacyName) as String?;
			let storedUserEmail = defaults.retrieve(usingKey: AuthenticationKeys.userEmail.legacyName) as String?;
			let storedIsMerchant = defaults.retrieve(usingKey: AuthenticationKeys.isMerchant.legacyName) as Bool?;

			guard let storedUserID = storedUserID else {
				return nil;
			}
			
			return UserAuthInfo(userID: storedUserID,
								name: storedName ?? "",
								username: "",
								email: storedUserEmail,
								userType: storedIsMerchant == nil ? nil : storedIsMerchant! ? .merchant : .customer);
		}
		
		// No legacy data, handle normal secure data
		let storedUserID = keychain.get(AuthenticationKeys.userID.rawValue);
		let storedName = keychain.get(AuthenticationKeys.name.rawValue);
		let storedUsername = keychain.get(AuthenticationKeys.username.rawValue);
		let storedUserEmail = keychain.get(AuthenticationKeys.userEmail.rawValue);
		let storedIsMerchant = keychain.getBool(AuthenticationKeys.isMerchant.rawValue);

		guard let storedUserID = storedUserID, let storedUsername = storedUsername else {
			return nil;
		}
		
		return UserAuthInfo(userID: storedUserID,
							name: storedName ?? "",
							username: storedUsername,
							email: storedUserEmail,
							userType: storedIsMerchant == nil ? nil : storedIsMerchant! ? .merchant : .customer);
	}

	private func clearUserInfo() -> Bool {
		// Clear legacy data
		if (legacyToken != nil) {
			defaults.remove(usingKey: AuthenticationKeys.userID.legacyName);
			defaults.remove(usingKey: AuthenticationKeys.name.legacyName);
			defaults.remove(usingKey: AuthenticationKeys.userEmail.legacyName);
			defaults.remove(usingKey: AuthenticationKeys.isMerchant.legacyName);
			legacyToken = nil;
		}

		// Clear normal data
		return keychain.delete(AuthenticationKeys.userID.rawValue)
			&& keychain.delete(AuthenticationKeys.name.rawValue)
			&& keychain.delete(AuthenticationKeys.username.rawValue)
			&& keychain.delete(AuthenticationKeys.userEmail.rawValue)
			&& keychain.delete(AuthenticationKeys.isMerchant.rawValue)
	}

	// MARK: - Types
	struct Auth {
		var token: String
		var tokenExpiry: Date?
	}
	
	struct UserAuthInfo {
		var userID: String
		var name: String
		var username: String
		var email: String?
		var userType: UserType?
	}
	
	enum AuthenticationKeys: String {
		case userToken
		case userTokenExpiry
		case userID
		case name
		case username
		case userEmail
		case isMerchant
		
		/// Legacy keys for the keys used in this new app.
		var legacyName: String {
			switch self {
				case .userToken: return "customerId"
				case .userID: return "userId"
				case .name: return "customerName"
				case .userEmail: return "customerEmail"
				case .isMerchant: return "isSeller"
				default: return ""
			}
		}
	}
}
