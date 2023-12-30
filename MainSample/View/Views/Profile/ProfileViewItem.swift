//
//  ProfileViewItem.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 24/05/2023.
//

import SwiftUI

struct ProfileViewItem: View {
	var text: String
	var icon: String?
	var iconIsSystemImage: Bool = false
	var showingOperationIndicator: Bool = false
	
	var body: some View {
		HStack {
			if let icon = icon {
				// TODO: Encapsulate repeated styles here
				if (!iconIsSystemImage) {
					Image(icon)
						.resizable()
						.scaledToFit()
						.frame(height: !DeviceTrait.isPad ? 22 : 33)
						.padding(.leading, 10)
				}
				else {
					Image(systemName: icon)
						.resizable()
						.scaledToFit()
						.frame(height: !DeviceTrait.isPad ? 22 : 33)
						.padding(.leading, 10)
				}
			}
			
			Text(text)
				.padding(.leading, 10)
				.textBaseStyle()
			
			Spacer()
			
			ZStack {
				if (!showingOperationIndicator) {
					Image("item-action")
						.resizable()
						.scaledToFit()
						.frame(width: ViewSpecs.scaledSize(of: 8.25), height: ViewSpecs.scaledSize(of: 15))
						.padding(.trailing, 10)
				}
				else {
					ProgressView()
						.frame(width: ViewSpecs.scaledSize(of: 8.25), height: ViewSpecs.scaledSize(of: 15))
						.padding(.trailing, 10)
				}
			}
		}
	}
}
