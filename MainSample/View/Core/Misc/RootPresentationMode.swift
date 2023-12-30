//
//  RootPresentationMode.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 19/03/2023.
//

// Credit: https://stackoverflow.com/a/61926030/7128177

import SwiftUI

struct RootPresentationModeKey: EnvironmentKey {
	static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
	var rootPresentationMode: Binding<RootPresentationMode> {
		get { return self[RootPresentationModeKey.self] }
		set { self[RootPresentationModeKey.self] = newValue }
	}
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
	
	public mutating func dismiss() {
		self.toggle()
	}
}
