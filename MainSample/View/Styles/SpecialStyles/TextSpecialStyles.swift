//
//  HomeStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/09/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func homeSectionHeadingStyle() -> some View { modifier(HomeSectionHeadingModifier()) }
	func homeSectionHeadingLinkStyle() -> some View { modifier(HomeSectionHeadingLinkModifier()) }
}

// MARK: - Modifiers
struct HomeSectionHeadingModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.textTitle)
			.font(AppFont(size: ViewSpecs.scaledSize(of: 16),
						  weight: .bold).font)
			.padding(.leading, ViewSpecs.leadingPadding)
			.padding(.trailing, ViewSpecs.leadingPadding)
	}
}

struct HomeSectionHeadingLinkModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.tintPrimary)
			.font(AppFont(size: ViewSpecs.scaledSize(of: 8),
						  weight: .regular).font)
	}
}
