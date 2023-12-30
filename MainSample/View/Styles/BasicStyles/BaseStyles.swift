//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

import SwiftUI

struct TextBaseModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.normal.font)
			.foregroundColor(.textPrimary)
	}
}

struct ButtonBaseModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.normal.font)
			.foregroundColor(.textPrimary)
	}
}

extension View {
	func textBaseStyle() -> some View { modifier(TextBaseModifier()) }
	func buttonBaseStyle() -> some View { modifier(ButtonBaseModifier()) }
}
