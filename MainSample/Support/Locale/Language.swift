//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

// Multi-Language Custom Solution
//
// Credit: https://stackoverflow.com/a/53442744/7128177

import Foundation

/// Enum containing all languages that the app supports
enum Language: Equatable, CaseIterable {
	case english
	case arabic

	// Language name string per enum value
	var code: String {
		switch self {
			case .english:              return "en"
			case .arabic:              return "ar"
		}
	}
	
	// Language code per enum value
	var name: String {
		switch self {
			case .english:              return "English"
			case .arabic:              return "العربية"
		}
	}

	// Init with language code
	init?(languageCode: String?) {
		guard let languageCode = languageCode else { return nil }
		
		switch languageCode {
			case "en":			    self = .english
			case "ar":			    self = .arabic
			default:                return nil
		}
	}
}
