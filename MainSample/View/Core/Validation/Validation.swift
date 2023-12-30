//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

// [deferred]TODO: May I separate validation logic in a dedicated struct/class? Or it's OK to be here? May I encapsulate each validation type in a method here?
// [deferred]TODO: May I convert this enum into a struct/class?
// MARK: - Validator
class Validator<T: Validatable>: ObservableObject {
	var validations: [Validation<T>]?
	@Published var isValid: Bool = true
	var validationMessages: [String]?
	
	init(forType type: T.Type, validations: [Validation<T>]? = nil, isValid: Bool = true, validationMessages: [String]? = nil) {
		self.validations = validations
		self.isValid = isValid
		self.validationMessages = validationMessages
	}
	
	func validate(_ value: T) {
		isValid = true;
		validationMessages = [];
		
		guard let validations = validations else {
			validationMessages = nil;
			return
		}
		
		for validation in validations {
			let isValid = validation.validate(value);
			if (!isValid) { validationMessages?.append(validation.errorMessage) }
			self.isValid =  self.isValid && isValid;
		}
	}
}

// MARK: - Validatable Types
protocol Validatable: Comparable { }
extension String: Validatable { }
extension Int: Validatable { }
extension Double: Validatable { }
extension Float: Validatable { }
extension Date: Validatable { }

// MARK: - Validation Logic
enum Validation<T: Validatable> {
	case required(errorMessage: String? = nil)
	case stringLengthRange(min: Int? = nil, max: Int, errorMessage: String? = nil)
	case numberRange(min: T, max: T, errorMessage: String? = nil)
	case username(errorMessage: String? = nil)
	case email(errorMessage: String? = nil)
	case phoneNumber(errorMessage: String? = nil)
	case pattern(regex: String, errorMessage: String? = nil)
	case custom(validationClosure: (T?) -> Bool, errorMessage: String? = nil)
	
	/// Validation logic
	func validate(_ item: T?) -> Bool {
		switch self {
			case .required:
				guard let item = item else {
					return false;
				}
				
				if (item is String) {
					let typedItem = item as! String;
					if (typedItem.trimmingCharacters(in: .whitespaces) == "") { return false }
					return true;
				}
				else {
					return true;
				}
				
			case .stringLengthRange(let min, let max, _):
				guard let item = item else {
					return min == nil ? true : false;
				}
				
				if (item is String) {
					let pattern = ValidationConstraints.stringLengthRangePattern
						.replacingOccurrences(of: "<<<0>>>", with: "\(min ?? 0)")
						.replacingOccurrences(of: "<<<1>>>", with: "\(max)");
					let typedItem = item as! String;
					
					return self.validateWithRegex(itemToValidate: typedItem, pattern: pattern);
				}
				else {
					return false;
				}
				
			case .numberRange(let min, let max, _):
				guard let item = item else {
					return false;
				}
				
				if (item is Int || item is Double || item is Float) {
					return (item >= min && item <= max);
				}
				else {
					return false;
				}
				
			case .username:
				guard let item = item else {
					return false;
				}
				
				if (item is String) {
					let pattern = ValidationConstraints.usernamePattern;
					let typedItem = item as! String;
					return self.validateWithRegex(itemToValidate: typedItem, pattern: pattern);
				}
				else {
					return false;
				}

			case .email:
				guard let item = item else {
					return false;
				}
				
				if (item is String) {
					let pattern = ValidationConstraints.emailPattern;
					let typedItem = item as! String;
					return self.validateWithRegex(itemToValidate: typedItem, pattern: pattern);
				}
				else {
					return false;
				}
				
			case .phoneNumber:
				guard let item = item else {
					return false;
				}
				
				if (item is String) {
					let pattern = ValidationConstraints.phoneNumberPattern;
					let typedItem = item as! String;
					return self.validateWithRegex(itemToValidate: typedItem, pattern: pattern);
				}
				else {
					return false;
				}
				
			case .pattern(let pattern, _):
				guard let item = item else {
					return false;
				}
				
				if (item is String) {
					let typedItem = item as! String;
					return self.validateWithRegex(itemToValidate: typedItem, pattern: pattern);
				}
				else {
					return false;
				}
				
			case .custom(let validationClosure, _):
				return validationClosure(item);
		}
	}
	
	/// Get error message
	var errorMessage: String {
		switch self {
			case .required(let errorMessage):
				guard let errorMessage = errorMessage else { return StaticErrorMessages.required }
				return errorMessage;
				
			case .stringLengthRange(let min, let max, let errorMessage):
				guard let errorMessage = errorMessage else {
					return StaticErrorMessages.stringLengthRange
						.replacingOccurrences(of: "{0}", with: "\(min)")
						.replacingOccurrences(of: "{1}", with: "\(max)");
				}
				return errorMessage;
				
			case .numberRange(let min, let max, let errorMessage):
				guard let errorMessage = errorMessage else {
					return StaticErrorMessages.numberRange
						.replacingOccurrences(of: "{0}", with: "\(min)")
						.replacingOccurrences(of: "{1}", with: "\(max)");
				}
				return errorMessage;
				
			case .username(let errorMessage):
				guard let errorMessage = errorMessage else { return StaticErrorMessages.username }
				return errorMessage;

			case .email(let errorMessage):
				guard let errorMessage = errorMessage else { return StaticErrorMessages.email }
				return errorMessage;
				
			case .phoneNumber(let errorMessage):
				guard let errorMessage = errorMessage else { return StaticErrorMessages.phoneNumber }
				return errorMessage;
				
			case .pattern(_, let errorMessage):
				guard let errorMessage = errorMessage else { return StaticErrorMessages.pattern }
				return errorMessage;
				
			case .custom(_, let errorMessage):
				guard let errorMessage = errorMessage else { return StaticErrorMessages.custom }
				return errorMessage;
		}
	}
	
	// MARK: - Privates
	private func validateWithRegex(itemToValidate: String, pattern: String) -> Bool {
		let trimmedItem = itemToValidate.trimmingCharacters(in: .whitespaces);
		let validation = NSPredicate(format: "SELF MATCHES %@", pattern);
		return validation.evaluate(with: trimmedItem);
	}
}

// MARK: - Static Error Messages
struct StaticErrorMessages {
	static let required = "Item is required!";
	static let stringLengthRange = "Item's length must be between {0} and {1}";
	static let numberRange = "Item must be between {0} and {1}";
	static let username = "Username format is not correct!";
	static let email = "Email format is not correct!";
	static let phoneNumber = "Phone number format is not correct!";
	static let pattern = "Item format is not correct!";
	static let custom = "Item is not valid!";
}
