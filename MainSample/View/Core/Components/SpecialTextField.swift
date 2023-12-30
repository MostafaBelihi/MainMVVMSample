//
//  SpecialTextField.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 05/03/2023.
//

import SwiftUI

struct SpecialTextField: View {
	
	// Data
	var placeholder: String
	@Binding var text: String
	
	// View specs
	var iconImageName: String?
	var isSecure: Bool = false
	var textContentType: UITextContentType = .name
	var textInputAutocapitalization: TextInputAutocapitalization = .sentences
	var disableAutocorrection: Bool = false
	var keyboardType: UIKeyboardType = .default
	
	var borderColor: Color = .lightGray
	
	// View interactions
	@FocusState private var focus1: Bool
	@FocusState private var focus2: Bool
	@State private var showPassword: Bool = false
	
	// View
    var body: some View {
		HStack {
			// Icon
			if let iconImageName = iconImageName {
				Image(iconImageName)
					.resizable()
					.scaledToFit()
					.frame(width: 20, height: 20)
					.foregroundColor(.gray.opacity(0.65))
			}
			
			ZStack {
				TextField(placeholder, text: $text)
					.textContentType(textContentType)
					.textInputAutocapitalization(textInputAutocapitalization)
					.disableAutocorrection(disableAutocorrection)
					.keyboardType(keyboardType)
					.focused($focus1)
					.opacity(!isSecure ? 1 : (showPassword ? 1 : 0))
					.formTextFieldStyle()
				
				if (isSecure) {
					SecureField(placeholder, text: $text)
						.textContentType(.password)
						.textInputAutocapitalization(.never)
						.disableAutocorrection(true)
						.focused($focus2)
						.opacity(showPassword ? 0 : 1)
						.formTextFieldStyle()
				}
			}
			
			if (isSecure) {
				// Eye button
				Button(action: {
					showPassword.toggle()
					if showPassword { focus1 = true } else { focus2 = true }
				}, label: {
					Image(showPassword ? "eye-unhide": "eye")
						.resizable()
						.frame(width: 31.37, height: showPassword ? 25 : 20)
				})
			}
		}
		.padding(15)
		.overlay(
			RoundedRectangle(cornerRadius: 5)
				.stroke(borderColor, lineWidth: 1.5)
		)
    }
}
