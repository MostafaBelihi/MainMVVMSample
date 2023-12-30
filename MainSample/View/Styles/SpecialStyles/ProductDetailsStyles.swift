//
//  ProductDetailsStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/08/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func productDetailsNameTextStyle() -> some View { modifier(ProductDetailsNameTextModifier()) }
	func productDetailsPriceTextStyle(disabled: Bool = false) -> some View { modifier(ProductDetailsPriceTextModifier(disabled: disabled)) }
	func productDetailsDiscountedPriceTextStyle() -> some View { modifier(ProductDetailsDiscountedPriceTextModifier()) }
	func productDetailsUnavailablePriceTextStyle() -> some View { modifier(ProductDetailsUnavailablePriceTextModifier()) }
}

// MARK: - Modifiers
struct ProductDetailsNameTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.big.fontSize, weight: .bold).font)
			.textBaseStyle()
	}
}

struct ProductDetailsPriceTextModifier: ViewModifier {
	var disabled: Bool = false
	
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: TextStyle.large.fontSize, weight: .bold).font)
			.foregroundColor(!disabled ? .tintPrimary : .gray)
			.textBaseStyle()
	}
}

struct ProductDetailsDiscountedPriceTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.gray)
			.font(AppFont(size: TextStyle.medium.fontSize, weight: .semibold).font)
	}
}

struct ProductDetailsUnavailablePriceTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.gray)
			.mediumTextStyle()
	}
}

// TODO: Refactor to be usable for more cases if needed
// TODO: Workaround for iOS 15, resolved in iOS 16
struct DiscountedPriceTextView: View {
	var text: String
	
	init(_ text: String) {
		self.text = text
	}
	
	var attributedString: AttributedString {
		var result = AttributedString(text)
		result.strikethroughStyle = Text.LineStyle(
			pattern: .solid, color: .gray)
		return result
	}
	
	var body: some View {
		Text(attributedString)
	}
}
