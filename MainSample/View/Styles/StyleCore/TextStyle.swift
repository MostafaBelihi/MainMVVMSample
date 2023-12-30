//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

import SwiftUI

enum TextStyle {
	case tiny
	case small
	case normal
	case medium
	case big
	case large

	var fontSize: CGFloat {
		// [planned]TODO: I changed font sizes here to be for iPad 1.5x times of the iPhone. Check any other custom font sizes in the project.
		switch self {
			case .tiny: return !DeviceTrait.isPad ? 10 : 15;
			case .small: return !DeviceTrait.isPad ? 15 : 22.5;
			case .normal: return !DeviceTrait.isPad ? 18 : 27;
			case .medium: return !DeviceTrait.isPad ? 20 : 30;
			case .big: return !DeviceTrait.isPad ? 25 : 37.5;
			case .large: return !DeviceTrait.isPad ? 30 : 45;
		}
	}
	
	var fontWeight: Font.Weight {
		switch self {
			case .tiny,
				 .small,
				 .normal: return .regular;

			case .medium,
				 .big: return .semibold;

			case .large: return .bold;

		}
	}
	
	var font: Font {
		return AppFont(size: fontSize, weight: fontWeight).font;
	}
}

// MARK: - Sizes
struct AppSizes {

}
