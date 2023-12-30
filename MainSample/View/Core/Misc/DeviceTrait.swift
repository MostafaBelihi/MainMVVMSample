//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

// Credit: https://stackoverflow.com/a/53006873/7128177

import UIKit

enum DeviceTrait {
	case wRhR
	case wChR
	case wRhC
	case wChC
	
	static var screenTrait: DeviceTrait {
		switch (UIScreen.main.traitCollection.horizontalSizeClass, UIScreen.main.traitCollection.verticalSizeClass) {
			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
				return .wRhR
			
			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
				return .wChR
			
			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
				return .wRhC
			
			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
				return .wChC
			
			default:
				return .wChR
		}
	}

	// [planned]TODO: Fix dependency on AppDelegate
	static var windowTrait: DeviceTrait {
		return .wChR
//		guard let window = AppDelegate.shared.window else {
//			fatalError("Unexpectedly did not find an app window!!!");
//		}
//		
//		switch (window.traitCollection.horizontalSizeClass, window.traitCollection.verticalSizeClass) {
//			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular):
//				return .wRhR
//				
//			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.regular):
//				return .wChR
//				
//			case (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.compact):
//				return .wRhC
//				
//			case (UIUserInterfaceSizeClass.compact, UIUserInterfaceSizeClass.compact):
//				return .wChC
//				
//			default:
//				return .wChR
//		}
	}
	
	// TODO: This property uses value in `UIDevice.current.userInterfaceIdiom` instead of normal use of the `DeviceTrait.windowTrait` property.
	// TODO: ... This is because the `DeviceTrait.windowTrait` still not adapted for SwiftUI use. This is OK for this project, but needs to be resolved.
	static var isLargeWindow: Bool {
//		return DeviceTrait.windowTrait == .wRhR;
		return UIDevice.current.userInterfaceIdiom == .pad;
	}
	
	static var isPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad;
	}
	
	static var isIPhoneSE2: Bool {
		return DeviceType.isIPhone6;
	}
}

struct ScreenSize {
  static let screenWidth = UIScreen.main.bounds.size.width
  static let screenHeight = UIScreen.main.bounds.size.height
  static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
  static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
  static let isIPhoneOrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
  static let isIPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
  static let isIPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
  static let isIPhone6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
}
