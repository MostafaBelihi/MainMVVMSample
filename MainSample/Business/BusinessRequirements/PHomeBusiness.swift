//
//  PHomeBusiness.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/03/2023.
//

import Foundation

protocol PHomeBusiness {
	func getAppGlobalData() async throws -> AppGlobalData
	func getHomeBanners() async throws -> [Banner]
	func loadAppSettings() -> AppSettings?
}
