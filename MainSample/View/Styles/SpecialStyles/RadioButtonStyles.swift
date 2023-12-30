//
//  RadioButtonStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/08/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func radioButtonTextDynamicStyle(isSmall: Bool, isGray: Bool) -> some View { modifier(RadioButtonTextDynamicModifier(isSmall: isSmall, isGray: isGray)) }
	
	func radioButtonTextStyle() -> some View { modifier(RadioButtonTextModifier()) }
	func radioButtonSmallTextStyle() -> some View { modifier(RadioButtonSmallTextModifier()) }

	func radioButtonGrayTextStyle() -> some View { modifier(RadioButtonGrayTextModifier()) }
	func radioButtonSmallGrayTextStyle() -> some View { modifier(RadioButtonSmallGrayTextModifier()) }
}

// MARK: - Modifiers
struct RadioButtonTextDynamicModifier: ViewModifier {
	var isSmall: Bool
	var isGray: Bool
	
	func body(content: Content) -> some View {
		if (!isSmall) {
			content
				.foregroundColor(!isGray ? .textPrimary : .gray)
				.radioButtonTextStyle()
		}
		else {
			content
				.foregroundColor(!isGray ? .textPrimary : .gray)
				.radioButtonSmallTextStyle()
		}
	}
}

struct RadioButtonTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.textBaseStyle()
	}
}

struct RadioButtonSmallTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.smallTextStyle()
	}
}

struct RadioButtonGrayTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.gray)
			.textBaseStyle()
	}
}

struct RadioButtonSmallGrayTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.gray)
			.smallTextStyle()
	}
}
