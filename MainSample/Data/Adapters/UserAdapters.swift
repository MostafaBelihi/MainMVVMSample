//
//  UserAuthAdapters.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

class APIAuthResponseToUserAuthAdapter: TypeAdapter {
	// APIAuthResponse -> UserAuth
	func convert(from model: APIAuthResponse) -> UserAuth {
		var tokenExpiry: Date?
		if let tokenExpireDate = model.tokenExpireDate {
			tokenExpiry = Date.fromString(tokenExpireDate, format: APIConstants.dateFormat, timeZone: APIConstants.serverTimeZone);
		}

		return UserAuth(userID: model.userId,
						email: nil,
						phoneNumber: nil,
						userType: nil,
						token: model.token ?? "",
						issuedAt: Date(),
						expires: tokenExpiry);
	}
}

class UserTypeToAPIUserTypeAdapter: TypeAdapter {
	// UserType -> APIRegisterStoreType
	func convert(from model: UserType) -> APIUserType {
		switch model {
			case .customer:
				return .customer;
			case .merchant:
				return .merchant;
		}
	}
}

class APIUserTypeToUserTypeAdapter: TypeAdapter {
	// APIUserType -> StoreType
	func convert(from model: APIUserType) -> UserType {
		switch model {
			case .customer:
				return .customer;
			case .merchant:
				return .merchant;
		}
	}
}
