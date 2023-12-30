//
//  Double.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 07/04/2023.
//

import Foundation

extension Double {
	func formatPrice(withSpecialTrimming: Bool = false) -> String {
		let rounded = "\(Math.round(number: self, decimalPoints: 2))";
		let parts = rounded.split(whereSeparator: { $0 == "." });
		let number = parts[0];

		var fraction = "";
		if (!withSpecialTrimming) {
			fraction = parts[1].count == 1 ? "\(parts[1])0" : "\(parts[1])";
		}
		else {
			if (parts[0].count >= 4) {
				if (parts[1] == "0") {
					fraction = "";
				}
				else {
					fraction = "\(parts[1])";
				}
			}
			else {
				fraction = parts[1].count == 1 ? "\(parts[1])0" : "\(parts[1])";
			}
		}
		
		return fraction == "" ? "\(number)" : "\(number).\(fraction)";
	}
}
