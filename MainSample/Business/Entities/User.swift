//
//  User.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/02/2023.
//

import Foundation

struct User {
	var id: String
	var firstName: String
	var lastName: String
	var email: String
	var phoneNumber: String
	var userType: UserType
}

struct UserAuth {
	var userID: String
	var name: String?
	var email: String?
	var phoneNumber: String?
	var userType: UserType?
	var token: String
	var issuedAt: Date?
	var expires: Date?
}

enum UserType {
	case customer
	case merchant
}
