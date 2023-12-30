//
//  View.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 07/03/2023.
//

import SwiftUI

#if canImport(UIKit)
extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
#endif

extension View {
	/// Styled placeholder for text fields.
	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content) -> some View {
			
			ZStack(alignment: alignment) {
				placeholder().opacity(shouldShow ? 1 : 0)
				self
			}
		}
}
