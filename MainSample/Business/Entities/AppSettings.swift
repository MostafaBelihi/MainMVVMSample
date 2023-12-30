//
//  AppSettings.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 18/04/2023.
//

import Foundation

// Global Settings
struct AppSettings: Codable {
	var hotLine: String
	
	var minimumOrderValue: Double
	var shippingCost: Double
	var freeShippingMinimumOrderValue: Double
	
	var serviceFees: Double
	
	// [tech-debt]TODO: Rush implementation, Refactor:
	// TODO: `Settings` class can be renamed to more broad name, and some user info like this be added to it and used wherever needed.
	var userWallet: Double?
}
