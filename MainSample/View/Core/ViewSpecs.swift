//
//  ViewSpecs.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 17/06/2023.
//

import Foundation

struct ViewSpecs {
	// Search Bar
	static let searchBarHeightCompact: CGFloat = !DeviceTrait.isPad ? 50 : 75;
	static let searchBarHeightExpanded: CGFloat = !DeviceTrait.isPad ? 120 : 180;
	static let searchTextFieldHeight: CGFloat = !DeviceTrait.isPad ? 40 : 60;
	
	// Global
	static let leadingPadding: CGFloat = !DeviceTrait.isPad ? 16 : 25;
	static let trailingPadding: CGFloat = !DeviceTrait.isPad ? 16 : 25;
	
	static let ipadScalingRatio: CGFloat = 1.5;

	// Big Button Sizes
	static let mainButtonHeight: CGFloat = !DeviceTrait.isPad ? 50 : 75
	
	// Corner Curves
	static let globalCornerRadius: CGFloat = !DeviceTrait.isPad ? 6 : 9;
	static let cartItemPlusMinusCornerRadius: CGFloat = !DeviceTrait.isPad ? 3 : 4.5;
}

extension ViewSpecs {
	static func scaledSize(of value: CGFloat) -> CGFloat {
		!DeviceTrait.isPad ? value : value * ViewSpecs.ipadScalingRatio
	}
}

enum Tab: String {
	case home
	case cart
	case merchants
	case profile
	
	var localizedName: String { rawValue.localized }
	var tabImage: String { "tab-\(rawValue)" }
	var tabImageSelected: String { "tab-\(rawValue)-selected" }
}

struct ImageNames {
	static let defaultPlaceholder = "placeholder";
	static let userPlaceholder = "user-placeholder";
	static let productPlaceholder = "product-placeholder";
}
