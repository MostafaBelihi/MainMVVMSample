//
//  ErrorAdapters.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/02/2023.
//

import Foundation

class DataErrorStringToAppErrorAdapter: TypeAdapter {
	// DataError<String> -> AppError
	func convert(from model: DataError<String>) -> AppError {
		return AppError(message: model.error,
						type: model.type);
	}
}

class DataErrorAPIErrorToAppErrorAdapter: TypeAdapter {
	// DataError<APIError> -> AppError
	func convert(from model: DataError<APIError>) -> AppError {
		var message:String?
		
		if let errors = model.error?.error, errors.count > 0 {
			message = errors[0];
		}
		
		return AppError(message: message,
						type: model.type);
	}
}

class DataErrorAPIAdvancedErrorToAppErrorAdapter: TypeAdapter {
	// DataError<APIAdvancedError> -> AppError
	func convert(from model: DataError<APIAdvancedError>) -> AppError {
		var message:String?
		
		if let errors = model.error?.error.errors, errors.count > 0 {
			message = errors[0].errorMessage;
		}
		
		return AppError(message: message,
						type: model.type);
	}
}
