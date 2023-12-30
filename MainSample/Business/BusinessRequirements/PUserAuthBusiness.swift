//
//  PUserAuthBusiness.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

protocol PUserAuthBusiness {
	func login(username: String, password: String) async throws -> Bool;
}
