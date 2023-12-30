//
//  LocalizablesSpecials.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/05/2023.
//

import Foundation

// Special localized text processings.
extension Localizables {
	/// Builds a text for piece counts.
	static func generatePiecesText(_ countValue: Double) -> String {
		let roundedCount = Int(countValue);
		
		switch roundedCount {
			case 1: return Localizables.pieces1.text;
			case 2: return Localizables.pieces2.text;
			case 3...10: return Localizables.pieces3to10.text.replacingOccurrences(of: "{0}", with: "\(roundedCount)");
			default: return Localizables.pieces11plus.text.replacingOccurrences(of: "{0}", with: "\(roundedCount)");
		}
	}
	
	/// Builds a text for `weightValue` according to its fraction of weight.
	/// `weightValue` is in kg.
	static func generateWeightText(_ weightValue: Double, isShort: Bool = false) -> String {
		let value = Math.round(number: weightValue, decimalPoints: 3);
		
		switch value {
			case 0.25:
				return !isShort ? "\(Localizables.quarter.text) \(Localizables.kilo.text)" : "\(Localizables.quarterShort.text) \(Localizables.kiloShort.text)";

			case 0.5:
				return !isShort ? "\(Localizables.half.text) \(Localizables.kilo.text)" : "\(Localizables.halfShort.text) \(Localizables.kiloShort.text)";

			case 0.75:
				return !isShort ? "\(Localizables.threeQuarter.text) \(Localizables.kilo.text)" : "\(Localizables.threeQuarterShort.text) \(Localizables.kiloShort.text)";

			case 1:
				return !isShort ? "1 \(Localizables.kilo.text)" : "1 \(Localizables.kiloShort.text)";

			case 0...0.999:
				let gramWeight = value * 1000;
				let gramWeightInt = Int(gramWeight);
				let weightText = (gramWeight == Double(gramWeightInt)) ? "\(gramWeightInt)" : "\(gramWeight)";
				return "\(weightText) \(!isShort ? Localizables.gram.text : Localizables.gramShort.text)"
				
			default:
				let weightValueInt = Int(value);
				let weightText = (value == Double(weightValueInt)) ? "\(weightValueInt)" : "\(value)";
				return "\(weightText) \(!isShort ? Localizables.kilo.text : Localizables.kiloShort.text)"
		}
	}
}
