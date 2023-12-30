//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

protocol PSimpleDataPersistence {
	func store<T: Codable>(_ item: T, usingKey key: String)
	func retrieve<T: Codable>(usingKey key: String) -> T?
	func remove(usingKey key: String)
}

class UserDefaultsManager: PSimpleDataPersistence {
	private let defaults = UserDefaults.standard;
	
	func store<T: Codable>(_ item: T, usingKey key: String) {
		if item is String || item is Int || item is Float || item is Double || item is Date {
			defaults.set(item, forKey:key);
		}
		else {
			defaults.set(try? PropertyListEncoder().encode(item), forKey:key);
		}
	}
	
	func retrieve<T: Codable>(usingKey key: String) -> T? {
		var restoredItem: T?;
		let data = defaults.value(forKey: key);
		
		if let data = data as? Data {
			restoredItem = try? PropertyListDecoder().decode(T.self, from: data);
		}
		else {
			restoredItem = data as? T;
		}
		
		return restoredItem;
	}
	
	func remove(usingKey key: String) {
		defaults.removeObject(forKey: key);
	}
}
