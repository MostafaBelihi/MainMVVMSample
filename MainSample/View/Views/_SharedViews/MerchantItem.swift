//
//  MerchantItem.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 15/09/2023.
//

import SwiftUI

struct MerchantItem: View {
	
	var item: Merchant
	
	var width: CGFloat
	var height: CGFloat?
	var thumbnailWidth: CGFloat
	
    var body: some View {
		HStack(spacing: ViewSpecs.scaledSize(of: 6)) {
			// Thumbnail Image
			ZStack {
				RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius)
					.fill(.lightGrayNew)
				
				AsyncImage(url: URL(string: item.imageURL ?? "")) { phase in
					if let image = phase.image {
						image
							.resizable()
							.merchantsListItemImageStyle()
					}
					else if phase.error != nil {
						// Error
						Image(ImageNames.userPlaceholder)
							.resizable()
							.merchantsListItemImageStyle()
					}
					else {
						// Placeholder
						Image(ImageNames.userPlaceholder)
							.resizable()
							.merchantsListItemImageStyle()
					}
				}
			}
			.frame(width: thumbnailWidth, height: thumbnailWidth)
			
			// Info
			VStack(alignment: .leading, spacing: 4) {
				ViewElements.makeFullWidthFiller(fillColor: .clear, height: ViewSpecs.scaledSize(of: 2))
				
				Text(item.name)
					.padding(.top, 1)
					.merchantsListItemNameStyle()

				Spacer()
			}
			.frame(maxWidth: .infinity)
		}
		.frame(width: width, height: height)
    }
}
