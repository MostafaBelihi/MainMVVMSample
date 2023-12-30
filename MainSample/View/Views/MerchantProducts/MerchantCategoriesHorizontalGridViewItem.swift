//
//  MerchantCategoriesHorizontalGridViewItem.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 01/10/2023.
//

import SwiftUI

struct MerchantCategoriesHorizontalGridViewItem: View {
	
	// MARK: - Data
	var id: Int?
	var name: String
	var selectedItemID: Int?	// by ID
	
	// MARK: - View Specs
	let height: CGFloat

	// MARK: - Body
	var body: some View {
		VStack {
			ZStack {
				VStack {
					Text(name)
						.foregroundColor(selectedItemID == id ? .textPrimary : Color(ColorRGB(r: 136, g: 136, b: 136)))
						.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: selectedItemID == id ? .bold : .semibold).font)
						.padding(.top, 3)
				}
				
				if (selectedItemID == id) {
					VStack {
						Spacer()
						ViewElements.makeFullWidthFiller(fillColor: .black, height: ViewSpecs.scaledSize(of: 2))
					}
				}
			}
			.frame(height: height)
		}
    }
}
