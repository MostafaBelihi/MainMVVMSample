//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2020 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

struct APIConstants {
	
	// MARK: - API
	static let baseDomain = "https://api-domain.com";		// Fake API base domain, for sample demo
	static let baseURL = "\(APIConstants.baseDomain)/api";

	static let staticStoreID = 5;
	static let defaultStore = APIStore(id: 5, name: "المنصورة");
	static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'";
	static let serverTimeZone = TimeZone.init(identifier: "UTC");

	
	// MARK: - General Constants
	// JSON decoder
	static let jsonDecoder: JSONDecoder = {
		let jsonDecoder = JSONDecoder();
		
		// Property casing
//		jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase;
		
		// Date format
		let dateFormatter = DateFormatter();
		dateFormatter.dateFormat = APIConstants.dateFormat;
		jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter);
		
		return jsonDecoder
	}();
	
	// JSON encoder
	static let jsonEncoder = JSONEncoder();
	
}
