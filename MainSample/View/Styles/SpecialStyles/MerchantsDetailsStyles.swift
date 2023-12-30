//
//  MerchantsDetailsStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 25/09/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func merchantsDetailsNameStyle() -> some View { modifier(MerchantsDetailsNameModifier()) }
	func merchantsDetailsOtherInfoStyle() -> some View { modifier(MerchantsDetailsOtherInfoModifier()) }
}

// MARK: - Modifiers
struct MerchantsDetailsNameModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.multilineTextAlignment(.leading)
			.font(AppFont(size: ViewSpecs.scaledSize(of: 16), weight: .bold).font)
			.foregroundColor(.white)
	}
}

struct MerchantsDetailsOtherInfoModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.multilineTextAlignment(.leading)
			.font(AppFont(size: ViewSpecs.scaledSize(of: 7), weight: .regular).font)
			.foregroundColor(.white)
	}
}
