//
//  ScrollingBannerView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 25/03/2023.
//

import SwiftUI

struct ScrollingBannerView: View {

	// Data
	var banners: [Banner]
	
	// Banner Actions
	@State private var activeBanner: Banner?		// to use for banner action
	@State private var showingBannerDestinationProduct = false
	@State private var showingBannerDestinationCategory = false
	@State private var showingBannerDestinationShareApp = false

	// Scolling
	private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
	@State private var offset = CGFloat.zero
	@State private var index = 0

	// View Specs
	var bannerWidth: CGFloat = ViewSpecs.scaledSize(of: 303)
	var bannerHeight: CGFloat = ViewSpecs.scaledSize(of: 120)
	let bannerSpacing: CGFloat = ViewSpecs.scaledSize(of: 16)
	
	init(banners: [Banner]) {
		self.banners = banners
		
		// Adjust if there is only one banner
		if (banners.count == 1) {
			let heightRatio = bannerHeight / bannerWidth;
			bannerWidth = UIScreen.main.bounds.width - (bannerSpacing * 2);
			bannerHeight = bannerWidth * heightRatio;
		}
	}
	
	var body: some View {
		VStack(spacing: 0) {
			ScrollViewReader { scrollView in
				ScrollView(.horizontal) {
					HStack(spacing: 0) {
						ForEach(banners, id: \.id) { item in
							AsyncImage(url: URL(string: item.image)) { phase in
								if let image = phase.image {
									image
										.resizable()
										.scaledToFill()
										.frame(width: bannerWidth, height: bannerHeight)
										.clipShape(RoundedRectangle(cornerRadius: 5))
								}
								else if phase.error != nil {
									// Error
									Image(ImageNames.defaultPlaceholder)
										.resizable()
										.scaledToFill()
										.frame(width: bannerWidth, height: bannerHeight)
										.clipShape(RoundedRectangle(cornerRadius: 5))
								}
								else {
									// Placeholder
									Group {
										ProgressView()
									}
									.frame(width: bannerWidth, height: bannerHeight)
								}
							}
							.padding((banners.last!.id == item.id) ? .horizontal : .leading,
									 bannerSpacing)
							.onTapGesture {
								switch item.type {
									case .product:
										showingBannerDestinationProduct = true;
										
									case .category:
										showingBannerDestinationCategory = true;
										
									case .magazine:
										if let url = item.url {
											Util.browse(urlPath: url);
										}
										
									case .shareTheApp:
										showingBannerDestinationShareApp = true;
								}
							}
						}
					}
					.onReceive(timer) { _ in
                        guard banners.count > 1 else { return }
                        
						withAnimation {
							index += 1;
							if (index > banners.count - 1) {
								index = 0;
							}
							
							scrollView.scrollTo(banners[index].id, anchor: .trailing);
						}
					}
				}
				.onAppear{
					scrollView.scrollTo(banners[0].id, anchor: .trailing);
				}
				
			}
			
			// Banner Destinations
			VStack(spacing: 0) {
				// Product
				NavigationLink("", destination: ProductDetailsView(productID: activeBanner?.productID ?? 0,
																   productName: "",
																   merchantID: activeBanner?.merchantID ?? "",
																   subCategoryID: activeBanner?.subCategoryId ?? 0),
							   isActive: $showingBannerDestinationProduct)
				.frame(height: 0)
				
				// Category
//				NavigationLink("", destination: ProductsBySubCategoryView(title: activeBanner?.title, subCategoryID: activeBanner?.subCategoryId ?? 0),
//							   isActive: $showingBannerDestinationCategory)
//				.frame(height: 0)
				
				// ShareApp
				// TODO: Deferred
			}
		}
	}
}
