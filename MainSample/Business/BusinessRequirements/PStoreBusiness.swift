//
//  PStoreBusiness.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 20/03/2023.
//

import Foundation

protocol PStoreBusiness {
	func loadStores() async throws -> [Store]
	func setActiveStore(_ store: Store)
	func getActiveStore() -> Store
}
