//
//  FormStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/08/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func formTitleStyle() -> some View { modifier(FormTitleModifier()) }
	func formFieldTitleStyle() -> some View { modifier(FormFieldTitleModifier()) }
	func formTextFieldStyle() -> some View { modifier(FormTextFieldModifier()) }
	func formValidationMessageStyle() -> some View { modifier(FormValidationMessageModifier()) }
	func formDimmedTextStyle() -> some View { modifier(FormDimmedTextModifier()) }
	func phoneVerificationCodeInputStyle() -> some View { modifier(PhoneVerificationCodeInputModifier()) }
}

// MARK: - Modifiers
struct FormTitleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.medium.font)
			.textBaseStyle()
	}
}

struct FormFieldTitleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.tintPrimary)
			.textBaseStyle()
	}
}

struct FormTextFieldModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.textBaseStyle()
	}
}

struct FormValidationMessageModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.small.font)
			.foregroundColor(.red)
	}
}

struct FormDimmedTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.gray)
			.textBaseStyle()
	}
}

struct PhoneVerificationCodeInputModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.big.font)
			.textBaseStyle()
	}
}
