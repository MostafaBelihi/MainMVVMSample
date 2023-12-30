//
//  FormTextInputItem.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 14/03/2023.
//

import SwiftUI

struct FormTextInputItem: View {
	
	// Data
	var labelText: String
	var placeholder: String
	@Binding var text: String
	@StateObject var validator: Validator<String>
	
	// View specs
	var iconImageName: String?
	var isSecure: Bool = false
	var textContentType: UITextContentType = .name
	var textInputAutocapitalization: TextInputAutocapitalization = .sentences
	var disableAutocorrection: Bool = false
	var keyboardType: UIKeyboardType = .default

	// View
	var body: some View {
		VStack(alignment: .leading) {
			Text(labelText)
				.formFieldTitleStyle()
			
			// Special Text Field
			SpecialTextField(placeholder: placeholder,
							 text: $text,
							 iconImageName: iconImageName,
							 isSecure: isSecure,
							 textContentType: textContentType,
							 textInputAutocapitalization: textInputAutocapitalization,
							 disableAutocorrection: disableAutocorrection,
							 keyboardType: keyboardType)
			
			// Validation
			if (!validator.isValid) {
				if let validationMessages = validator.validationMessages, validationMessages.count > 0 {
					Text(validationMessages[0])
						.formValidationMessageStyle()
				}
			}
		}
    }
}
