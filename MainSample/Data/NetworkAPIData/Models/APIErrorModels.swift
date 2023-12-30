//
//  APIErrorModels.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 07/03/2023.
//

import Foundation

struct APIError: Codable {
	var error: [String]
}

// MARK: - APIAdvancedError
struct APIAdvancedError: Codable {
	var error: APIError2
}

struct APIError2: Codable {
	var errors: [APIErrorElement]
}

struct APIErrorElement: Codable {
	var exception: String?
	var errorMessage: String
}
