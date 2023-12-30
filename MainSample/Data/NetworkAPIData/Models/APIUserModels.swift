//
//  APIUserModels.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/02/2023.
//

import Foundation

// MARK: - Auth (Login, Reg.)
struct APILoginRequest: Codable {
	var userName: String
	var password: String
}

struct APIAuthResponse: Codable {
	var userId: String
	var token: String?
	var tokenExpireDate: String?
}

// MARK: - Register User Device
struct APISyncUserDeviceRequest: Codable {
	var userId: String
	var deviceId: String
}
