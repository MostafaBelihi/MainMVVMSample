//
//  SearchTextBox.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 08/04/2023.
//

import SwiftUI

struct SearchTextBox: View {
	
	// Data
	@Binding var text: String
	@Binding var barCode: String

	var placeholder: String? = nil
	var placeholderCondition: Bool = false

	// View Specs
	var height: CGFloat
	var paddingVertical: CGFloat = !DeviceTrait.isPad ? 5 : 7.5
	var paddingHorizontal: CGFloat = !DeviceTrait.isPad ? 15 : 22.5
	var textFieldHeight: CGFloat {
		height - (paddingVertical * 2)
	}

	// Actions
	var onDismissBarCode: () -> Void
	var onSubmit: () -> Void

	// Body
	var body: some View {
		HStack(spacing: 0) {
			HStack {
				Image("search")
					.resizable()
					.scaledToFit()
					.frame(width: !DeviceTrait.isPad ? 15 : 22.5)
					.padding(.leading, 5)
					.foregroundColor(.tintPrimary)
				
				TextField("", text: $text)
					.submitLabel(.search)
					.formTextFieldStyle()
					.placeholder(placeholder, when: placeholderCondition)
					.frame(height: textFieldHeight)
					.onSubmit {
						guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
						onSubmit()
					}
			}
			
			BarcodeSearchButton(code: $barCode, onDismiss: {
				guard !barCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
				onDismissBarCode()
			})
		}
		.padding(.vertical, paddingVertical)
		.padding(.horizontal, paddingHorizontal)
		.background(.white)
		.clipShape(RoundedRectangle(cornerRadius: height / 2))
	}
}
