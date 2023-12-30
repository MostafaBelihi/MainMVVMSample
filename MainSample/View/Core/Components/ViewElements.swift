//
//  ViewElements.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 02/08/2023.
//

import SwiftUI

struct ViewElements {
	// MARK: - Static Views
	static var navBarExtension: some View {
		Rectangle()
			.fill(.backgroundTinted)
			.frame(height: 10)
	}
	
	static var verticalLineSeparator: some View {
		Rectangle()
			.frame(height: 1.5)
			.foregroundColor(.lightGray2)
	}
	
	// MARK: - View Builders
	static func makeFullWidthFiller(fillColor: Color, height: CGFloat) -> some View {
		Rectangle()
			.fill(fillColor)
			.frame(height: height)
			.frame(maxWidth: .infinity)
	}
	
	static func buildMerchantDeliveryDuration(durationText: String, withLightBackground: Bool = false) -> some View {
		HStack(spacing: ViewSpecs.scaledSize(of: 3)) {
			Image("timing")
				.foregroundColor(withLightBackground ? .white : .tintPrimary)
			
			Text(durationText)
				.multilineTextAlignment(.leading)
				.foregroundColor(withLightBackground ? .white : .tintPrimary)
				.font(AppFont(size: ViewSpecs.scaledSize(of: 4), weight: .semibold).font)
		}
		.padding(.horizontal, ViewSpecs.scaledSize(of: 6))
		.frame(height: ViewSpecs.scaledSize(of: 12))
		.background(withLightBackground ? .tintPrimary : .white)
		.clipShape(RoundedRectangle(cornerRadius: ViewSpecs.scaledSize(of: 12)))
	}
}
