//
//  ButtonViewStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/02/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func primaryButtonStyle(cornerRadius: CGFloat, disabled: Bool = false) -> some View { modifier(PrimaryButtonModifier(cornerRadius: cornerRadius, disabled: disabled)) }
	func secondaryButtonStyle(cornerRadius: CGFloat, disabled: Bool = false) -> some View { modifier(SecondaryButtonModifier(cornerRadius: cornerRadius, disabled: disabled)) }
	func grayButtonStyle() -> some View { modifier(GrayButtonModifier()) }
	func plainButtonStyle() -> some View { modifier(PlainButtonModifier()) }
}

// MARK: - Modifiers
struct PrimaryButtonModifier: ViewModifier {
	var cornerRadius: CGFloat
	var disabled: Bool = false

	func body(content: Content) -> some View {
		content
			.background(!disabled ? .tintPrimary : .gray)
			.foregroundColor(.white)
			.buttonBaseStyle()
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
	}
}

struct SecondaryButtonModifier: ViewModifier {
	var cornerRadius: CGFloat
	var disabled: Bool = false

	func body(content: Content) -> some View {
		content
			.background(.white)
			.foregroundColor(!disabled ? .tintPrimary : .gray)
			.buttonBaseStyle()
			.overlay(
				RoundedRectangle(cornerRadius: cornerRadius)
					.stroke(!disabled ? .tintPrimary : .gray, lineWidth: 0.5)
			)
	}
}

struct GrayButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.normal.fontSize - 1, weight: TextStyle.normal.fontWeight).font)
			.foregroundColor(.textSecondary)
			.buttonBaseStyle()
	}
}

struct PlainButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.tintPrimary)
			.buttonBaseStyle()
	}
}
