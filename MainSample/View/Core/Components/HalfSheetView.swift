//
//  HalfSheetView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 12/08/2023.
//

import SwiftUI

/// This view is just a container to show SwiftUI content in a partial pop-up making use of the UISheetPresentationController in UIKit added to iOS 15.
/// Use this to implement a half sheet in iOS 15. If your min version is iOS 16, it has a native SwiftUI implementation for that.
struct HalfSheetView<Content>: UIViewControllerRepresentable where Content : View {
	private let content: Content
	
	@inlinable init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	
	func makeUIViewController(context: Context) -> HalfSheetController<Content> {
		return HalfSheetController(rootView: content)
	}
	
	func updateUIViewController(_: HalfSheetController<Content>, context: Context) {

	}
}

class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let presentation = sheetPresentationController {
			// configure at will
			presentation.detents = [.medium()]
			presentation.prefersGrabberVisible = false
		}
	}
}
