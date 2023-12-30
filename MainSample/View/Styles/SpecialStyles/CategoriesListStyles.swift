//
//  CategoriesListStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 06/08/2023.
//

import SwiftUI

// MARK: - Extensions
extension View {
	func categoriesListItemNameStyle(leadingPadding: CGFloat? = nil, 
									 trailingPadding: CGFloat? = nil,
									 isSelected: Bool = false) -> some View {
		
		modifier(CategoriesListItemNameModifier(leadingPadding: leadingPadding,
												trailingPadding: trailingPadding,
												isSelected: isSelected))
	}
}

// MARK: - Modifiers
struct CategoriesListItemNameModifier: ViewModifier {
	var leadingPadding: CGFloat?
	var trailingPadding: CGFloat?
	var isSelected: Bool = false

	func body(content: Content) -> some View {
		content
			.foregroundColor(!isSelected ? .textTitle : .tintPrimary)
			.headingTextStyle()
			.padding(.leading, leadingPadding ?? 0)
			.padding(.trailing, trailingPadding ?? 0)
	}
}
