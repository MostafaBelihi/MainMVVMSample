//
//  AppError.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

// TODO: Add to Infrastructure
struct AppError: PError {
	var code: String?
	var propertyName: String?
	var message: String?
	var type: ErrorType;
	
	var localizedMessage: String? {
		guard let code = code else { return nil }
		
		let errorMessage = NSLocalizedString(code, comment: "");
		
		if (errorMessage == code) {
			// No localized text for this key (code)
			return nil;
		}
		else {
			return errorMessage;
		}
	}
}
