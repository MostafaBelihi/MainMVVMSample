//
//  Util.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 09/04/2023.
//

import UIKit

final class Util {
	static func browse(urlPath: String) {
		guard let url = URL(string: urlPath),
			  UIApplication.shared.canOpenURL(url) else {
				  return
			  }
		
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}
	
	static func checkIfAppMustUpdate(newVersion: String?) -> Bool {
		guard let currentVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines),
				let newVersion = newVersion?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return false;
		}
		
		let currentVersionValue = convertAppVersionValue(currentVersion);
		let newVersionValue = convertAppVersionValue(newVersion);
		
		return newVersionValue > currentVersionValue;
		
		/// This method suppose that the version has most 4 digits.
		func convertAppVersionValue(_ version: String) -> Int {
			let versionDigits = version.split(separator: ".");
			var versionValue = 0;
			
			var index = 0;
			var factor = 1000;
			
			for value in versionDigits {
				let digit = Int(value) ?? 0;
				versionValue = versionValue + digit * factor;
				
				index += 1;
				factor = factor / 10;
			}

			print("versionValue: \(versionValue)");
			return versionValue;
		}
	}
}
