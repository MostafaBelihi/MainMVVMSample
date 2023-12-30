//
//  ProductsListStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/08/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func productsListPriceTextStyle(isLongNumber: Bool = false) -> some View { modifier(ProductsListPriceTextModifier(isLongNumber: isLongNumber)) }
	func productsListDiscountedPriceTextStyle() -> some View { modifier(ProductsListDiscountedPriceTextModifier()) }
	func productsListUnavailablePriceTextStyle() -> some View { modifier(ProductsListUnavailablePriceTextModifier()) }
}

// MARK: - Modifiers
struct ProductsListPriceTextModifier: ViewModifier {
	var isLongNumber: Bool = false
	
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: ViewSpecs.scaledSize(of: 24), weight: .bold).font)
			.foregroundColor(.tintPrimary)
	}
}

struct ProductsListDiscountedPriceTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(AppFont(size: ViewSpecs.scaledSize(of: 12), weight: .bold).font)
			.foregroundColor(Color(ColorRGB(r: 136, g: 136, b: 136)))
	}
}

struct ProductsListUnavailablePriceTextModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.gray)
			.smallTextStyle()
	}
}
