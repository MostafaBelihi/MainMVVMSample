//
//  NavBarStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 05/03/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func tintedNavBarStyle() -> some View { modifier(TintedNavBarModifier()) }
	func plainNavBarStyle() -> some View { modifier(PlainNavBarModifier()) }
	func plainNavBarTitleStyle() -> some View { modifier(PlainNavBarTitleModifier()) }
	func tintedNavBarTitleStyle() -> some View { modifier(TintedNavBarTitleModifier()) }
	func navBarButtonStyle() -> some View { modifier(NavBarButtonModifier()) }
}

// MARK: - Modifiers
struct TintedNavBarModifier: ViewModifier {
	init() {
		let coloredAppearance = UINavigationBarAppearance()
		coloredAppearance.configureWithTransparentBackground()
		coloredAppearance.backgroundColor = UIColor(.backgroundTinted)
		coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		coloredAppearance.shadowColor = .clear
		
		UINavigationBar.appearance().standardAppearance = coloredAppearance
		UINavigationBar.appearance().compactAppearance = coloredAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
		UINavigationBar.appearance().tintColor = .white
	}
	
	func body(content: Content) -> some View {
		content
			.navigationBarTitleDisplayMode(.inline)
	}
}

struct PlainNavBarModifier: ViewModifier {
	init() {
		let coloredAppearance = UINavigationBarAppearance()
		coloredAppearance.configureWithTransparentBackground()
		coloredAppearance.backgroundColor = UIColor(.white)
		coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(.tintPrimary)]
		coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.tintPrimary)]
		coloredAppearance.shadowColor = .clear
		
		UINavigationBar.appearance().standardAppearance = coloredAppearance
		UINavigationBar.appearance().compactAppearance = coloredAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
		UINavigationBar.appearance().tintColor = .white
	}
	
	func body(content: Content) -> some View {
		content
			.navigationBarTitleDisplayMode(.inline)
	}
}

struct PlainNavBarTitleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.tintPrimary)
			.font(AppFont(size: 25, weight: .semibold).font)
	}
}

struct TintedNavBarTitleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.white)
			.font(AppFont(size: 20, weight: .semibold).font)
	}
}

struct NavBarButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.foregroundColor(.tintPrimary)
	}
}
