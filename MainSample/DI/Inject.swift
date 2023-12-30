//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

// Credit: https://obscuredpixels.com/wrapping-dependencies-in-swiftui

import Foundation

@propertyWrapper
struct Inject<Component> {
	let wrappedValue: Component
	
	init() {
		self.wrappedValue = DependencyInjector.shared.resolve(Component.self);
	}
}
