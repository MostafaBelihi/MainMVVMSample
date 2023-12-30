//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

import SwiftUI

// MARK: - Color Codes
struct AppColor {
	// Background
	static let backgroundSecondary = ColorRGB(r: 252, g: 252, b: 252);
	static let backgroundTinted = ColorRGB(r: 38, g: 128, b: 255);
	static let backgroundTinted2 = ColorRGB(r: 31, g: 104, b: 205);

	// Text
	static let textSecondary = ColorRGB(r: 98, g: 98, b: 98);
	static let textTitle = ColorRGB(r: 51, g: 51, b: 51);
	
	// Tint
	static let tintPrimary = ColorRGB(r: 38, g: 128, b: 255);
	static let tintSecondary = ColorRGB(r: 31, g: 104, b: 205);
	static let tintSecondary2 = ColorRGB(r: 14, g: 46, b: 92);
	
	// Special Colors
	static let lightGray = "E8E8E8";
	static let lightGray2 = "DADADA";
	static let lightGray3 = ColorRGB(r: 242, g: 242, b: 242);
	static let lightGrayNew = ColorRGB(r: 231, g: 235, b: 239);
	
	static let yellowSpecial = ColorRGB(r: 252, g: 238, b: 33);
	
	static let blackSpecial = ColorRGB(r: 51, g: 51, b: 51);

	static let danger = ColorRGB(r: 177, g: 54, b: 52);
	
	// Home
	static let merchantTypesBackground = ColorRGB(r: 233, g: 240, b: 250);
	
	static let bannerSelectedIndicator = ColorRGB(r: 234, g: 173, b: 43);
	static let bannerIndicator = ColorRGB(r: 238, g: 238, b: 238);
}

// MARK: - Colors
extension ShapeStyle where Self == Color {
	// Background
	static var backgroundPrimary: Color { .white }
	static var backgroundSecondary: Color {
		let color = AppColor.backgroundSecondary;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	static var backgroundTinted: Color {
		let color = AppColor.backgroundTinted;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	static var backgroundTinted2: Color {
		let color = AppColor.backgroundTinted2;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	
	// Text
	static var textPrimary: Color { .black }
	static var textSecondary: Color {
		let color = AppColor.textSecondary;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	static var textTitle: Color {
		let color = AppColor.textTitle;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}

	
	// Text inputs

	
	// Tint
	static var tintPrimary: Color {
		let color = AppColor.tintPrimary;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	static var tintSecondary: Color {
		let color = AppColor.tintSecondary;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	static var tintSecondary2: Color {
		let color = AppColor.tintSecondary2;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}

	// Numeric figures

	
	// Special Colors
	static var lightGray: Color { Color(hex: AppColor.lightGray) }
	static var lightGray2: Color { Color(hex: AppColor.lightGray2) }
	static var lightGray3: Color {
		let color = AppColor.lightGray3;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	static var lightGrayNew: Color {
		let color = AppColor.lightGrayNew;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}

	static var yellowSpecial: Color {
		let color = AppColor.yellowSpecial;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}

	static var blackSpecial: Color {
		let color = AppColor.blackSpecial;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}

	static var danger: Color {
		let color = AppColor.danger;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	
	// Home
	static var merchantTypesBackground: Color {
		let color = AppColor.merchantTypesBackground;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	
	static var bannerSelectedIndicator: Color {
		let color = AppColor.bannerSelectedIndicator;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
	
	static var bannerIndicator: Color {
		let color = AppColor.bannerIndicator;
		return Color(.displayP3,
					 red: color.redValue,
					 green: color.greenValue,
					 blue: color.blueValue);
	}
}

// MARK: - ColorRGB
struct ColorRGB {
	var r: Int
	var g: Int
	var b: Int
	
	var redValue: Double { Double(r) / 255 }
	var greenValue: Double { Double(g) / 255 }
	var blueValue: Double { Double(b) / 255 }
}

// MARK: - Color Extension
// Credit: https://stackoverflow.com/a/56874327/7128177
extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
			case 3: // RGB (12-bit)
				(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
			case 6: // RGB (24-bit)
				(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
			case 8: // ARGB (32-bit)
				(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
			default:
				(a, r, g, b) = (1, 1, 1, 0)
		}
		
		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue:  Double(b) / 255,
			opacity: Double(a) / 255
		)
	}
	
	init(_ rgb: ColorRGB) {
		self.init(.displayP3,
				  red: rgb.redValue,
				  green: rgb.greenValue,
				  blue: rgb.blueValue);
	}
}
