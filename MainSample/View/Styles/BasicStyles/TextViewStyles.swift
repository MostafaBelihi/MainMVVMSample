//
//  TextViewStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 28/02/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func headingTextStyle() -> some View { modifier(HeadingTextModifier()) }
	func mediumTextStyle() -> some View { modifier(MediumTextModifier()) }
	func normalTexStyle() -> some View { modifier(NormalTextModifier()) }
	func semiBoldNormalTextStyle() -> some View { modifier(SemiBoldNormalTextModifier()) }
	func boldNormalTextStyle() -> some View { modifier(BoldNormalTextModifier()) }
	func smallTextStyle() -> some View { modifier(SmallTextModifier()) }
	func boldSmallTextStyle() -> some View { modifier(BoldSmallTextModifier()) }
	func semiBoldSmallTextStyle() -> some View { modifier(SemiBoldSmallTextModifier()) }
}

// MARK: - Modifiers
struct HeadingTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.medium.font)
			.textBaseStyle()
	}
}

struct MediumTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.medium.fontSize, weight: .regular).font)
			.textBaseStyle()
	}
}

struct NormalTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.textBaseStyle()
	}
}

struct SemiBoldNormalTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.normal.fontSize, weight: .semibold).font)
			.textBaseStyle()
	}
}

struct BoldNormalTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.normal.fontSize, weight: .bold).font)
			.textBaseStyle()
	}
}

struct SmallTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(TextStyle.small.font)
			.textBaseStyle()
	}
}

struct BoldSmallTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.small.fontSize, weight: .bold).font)
			.textBaseStyle()
	}
}

struct SemiBoldSmallTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.small.fontSize, weight: .semibold).font)
			.textBaseStyle()
	}
}
