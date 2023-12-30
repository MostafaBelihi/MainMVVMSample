//
//  MerchantsListStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/08/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func merchantsListItemImageStyle() -> some View { modifier(MerchantsListItemImageModifier()) }
	func merchantsListItemNameStyle() -> some View { modifier(MerchantsListItemNameModifier()) }
	func merchantsListItemOtherInfoStyle() -> some View { modifier(MerchantsListItemOtherInfoModifier()) }
}

// MARK: - Modifiers
struct MerchantsListItemImageModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.scaledToFit()
			.clipShape(RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius))
	}
}

struct MerchantsListItemNameModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.multilineTextAlignment(.leading)
			.font(AppFont(size: ViewSpecs.scaledSize(of: 16), weight: .semibold).font)
			.foregroundColor(.tintSecondary2)
	}
}

struct MerchantsListItemOtherInfoModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.multilineTextAlignment(.leading)
			.font(AppFont(size: ViewSpecs.scaledSize(of: 6), weight: .regular).font)
			.foregroundColor(.tintSecondary2)
	}
}
