//
//  RadioButton.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/08/2023.
//

import SwiftUI

// TODO: Refcator all proprietary implementation of radio buttons to use this component.
struct RadioButton<Value: Equatable>: View {
	var text: String
	var secondaryText: String?

	var value: Value
	@Binding var bindingItem: Value
	
	var isSmall: Bool = false
	
    var body: some View {
		HStack(alignment: .top, spacing: 10) {
			// Proportions of `isSmall` sizes in this block is built on proportion of `fontSize` berween `TextStyle.small` and `TextStyle.normal`.
			ZStack {
				Circle()
					.stroke(
						.tintPrimary,
						lineWidth: 1.5
					)
					.frame(height: !DeviceTrait.isPad ? isSmall ? 16.6 : 20 : isSmall ? 24.9 : 30)
				
				if (bindingItem == value) {
					Circle()
						.fill(.tintPrimary)
						.frame(height: !DeviceTrait.isPad ? isSmall ? 8.3 : 10 : isSmall ? 12.45 : 15)
				}
			}
			.frame(width: !DeviceTrait.isPad ? isSmall ? 24.9 : 30 : isSmall ? 37.35 : 45)
			
			VStack(alignment: .leading, spacing: 10) {
				Text(text)
					.radioButtonTextDynamicStyle(isSmall: isSmall, isGray: false)
				
				if let secondaryText = secondaryText {
					Text(secondaryText)
						.radioButtonTextDynamicStyle(isSmall: isSmall, isGray: true)
				}
			}
			
			Spacer()
		}
		.padding(.vertical, 8)
		.frame(maxWidth: .infinity)
		.background(.backgroundPrimary)
		.onTapGesture {
			bindingItem = value
		}
    }
}

//#Preview {
//    RadioButton()
//}
