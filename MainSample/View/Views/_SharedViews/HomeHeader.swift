//
//  HomeHeader.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 03/08/2023.
//

import SwiftUI

struct HomeHeader: View {
	
	// Data
	@Binding var searchQuery: String
	@Binding var barCode: String
	
	var searchPlaceholder: String? = nil
	var searchPlaceholderCondition: Bool = false

	// View Specs
	var height: CGFloat
	var isExpanded: Bool = false
	
	// View Elements
	var searchTextBox: some View {
		SearchTextBox(text: $searchQuery,
					  barCode: $barCode,
					  placeholder: searchPlaceholder,
					  placeholderCondition: searchPlaceholderCondition,
					  height: ViewSpecs.searchTextFieldHeight,
					  onDismissBarCode: onDismissBarCode,
					  onSubmit: onSubmit)
	}

	// Actions
	var onDismissBarCode: () -> Void
	var onSubmit: () -> Void

	// Body
    var body: some View {
		VStack(spacing: 10) {
			Rectangle()
				.fill(.backgroundTinted)
				.frame(height: 0.0001)

			HStack {
				if (isExpanded) {
					// Logo
					VStack(spacing: 0) {
						Image("home-header-logo2")
							.resizable()
							.scaledToFit()
							.frame(height: !DeviceTrait.isPad ? 43 : 64.5)
						
						VStack {
							Text(Localizables.headerSlogan.text)
								.foregroundColor(.backgroundTinted)
								.font(AppFont(size: !DeviceTrait.isPad ? 12 : 18, weight: .bold).font)
						}
						.padding(.horizontal, 8)
						.padding(.vertical, 3)
						.background(.yellowSpecial)
						.clipShape(RoundedRectangle(cornerRadius: 5))
					}
					
					Spacer()
				}
				else {
					searchTextBox
				}
				
				// StoreSelector
				StoreSelector(isExpanded: isExpanded)
			}
			
			// Search
			if (isExpanded) {
				searchTextBox
			}
		}
		.frame(height: height)
		.padding(.horizontal, ViewSpecs.leadingPadding)
		.padding(.bottom, 10)
		.background(.backgroundTinted)
    }
}
