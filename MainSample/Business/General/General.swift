//
//  General.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

struct GlobalConstants {
	public static let appStoreLink = "https://apps.apple.com/app/dummy-app-id";
	
	static let defaultPageSize = 10
	
    static let privacyPolicyLink = "https://domain.com/#/privacyterms";
    static let returnPolicyLink = "https://domain.com/#/returnpolicy";
}

typealias VoidClosure = () -> Void;

struct OperationResult {
	var succeeded: Bool
	var message: String?
	var errorType: ErrorType?
}
