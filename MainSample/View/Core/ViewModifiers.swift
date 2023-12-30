//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

import SwiftUI

struct ViewLoadModifier: ViewModifier {
	@State private var viewDidLoad = false
	let action: (() -> Void)?
	
	func body(content: Content) -> some View {
		content
			.onAppear {
				if viewDidLoad == false {
					viewDidLoad = true
					action?()
				}
			}
	}
}

extension View {
	func onViewLoad(perform action: (() -> Void)? = nil) -> some View {
		modifier(ViewLoadModifier(action: action))
	}
}
