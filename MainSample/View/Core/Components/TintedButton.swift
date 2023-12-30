//
//  TintedButton.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 14/03/2023.
//

import SwiftUI

struct TintedButton: View {
	var title: String
	
	var height: CGFloat
	var cornerRadius: CGFloat
	
	var font: Font? = nil
	var spinningIndicator: Binding<Bool>?
	var disabled: Bool = false
	
	var leadingImage: Image?
	var leadingImagePadding: CGFloat? = !DeviceTrait.isPad ? 15 : 22.5
	
	var trailingImage: Image?
	var trailingImagePadding: CGFloat? = !DeviceTrait.isPad ? 15 : 22.5
	
	var inlineLeadingImage: Image?
	var inlineLeadingImageWidth: CGFloat? = ViewSpecs.scaledSize(of: 15)
	var inlineLeadingImageHeight: CGFloat? = ViewSpecs.scaledSize(of: 15)

	var inlineTrailingImage: Image?
	var inlineTrailingImageWidth: CGFloat? = ViewSpecs.scaledSize(of: 15)
	var inlineTrailingImageHeight: CGFloat? = ViewSpecs.scaledSize(of: 15)

	var inlineImageSpacing: CGFloat? = ViewSpecs.scaledSize(of: 5)

	var action: () -> Void

    var body: some View {
		ZStack {
			Button(action: action) {
				ZStack {
					HStack(spacing: inlineImageSpacing) {
						if let inlineLeadingImage = inlineLeadingImage {
							inlineLeadingImage
								.resizable()
								.scaledToFit()
								.frame(width: inlineLeadingImageWidth,
									   height: inlineLeadingImageHeight)
						}
						
						Text(title)
							.font(font ?? TextStyle.normal.font)

						if let inlineTrailingImage = inlineTrailingImage {
							inlineTrailingImage
								.resizable()
								.scaledToFit()
								.frame(width: inlineTrailingImageWidth,
									   height: inlineTrailingImageHeight)
						}
					}
					
					HStack {
						if let leadingImage = leadingImage {
							leadingImage
								.padding(.leading, leadingImagePadding)
						}

						Spacer()
						
						if let trailingImage = trailingImage {
							if (!(spinningIndicator?.wrappedValue ?? false)) {
								trailingImage
									.padding(.trailing, trailingImagePadding)
							}
						}
					}
				}
				.frame(maxWidth: .infinity)
				.frame(height: height)
				.primaryButtonStyle(cornerRadius: cornerRadius, disabled: disabled)
			}
			.disabled(disabled)
			
			if (spinningIndicator?.wrappedValue ?? false) {
				HStack {
					Spacer()
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .white))
						.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
						.padding(.trailing, !DeviceTrait.isPad ? 15 : 22.5)
					
				}
			}
		}
    }
}
