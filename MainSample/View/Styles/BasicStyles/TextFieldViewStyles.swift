//
//  TextFieldViewStyles.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 25/03/2023.
//

import SwiftUI

extension View {
	func placeholder(
		_ text: String?,
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		color: Color = .gray) -> some View {
			
			placeholder(when: shouldShow, alignment: alignment) {
				if let text = text {
					Text(text)
						.foregroundColor(color)
						.smallTextStyle()
				}
			}
		}
}
