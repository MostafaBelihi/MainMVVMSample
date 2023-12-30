//
//  RecommendedMerchantsGridView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 03/08/2023.
//

import SwiftUI

struct RecommendedMerchantsGridView: View {
	
	// MARK: - Data
	var items: [Merchant]
	
	// MARK: - View Specs
	private let leadingSpace: CGFloat = ViewSpecs.leadingPadding;
	private let trailingSpace: CGFloat = ViewSpecs.trailingPadding;
	
	private let itemSpacing: CGFloat = ViewSpecs.scaledSize(of: 12)
	private var gridItemWidth: CGFloat = ViewSpecs.scaledSize(of: 273)
	private var gridItemHeight: CGFloat = ViewSpecs.scaledSize(of: 60)
	private var gridLayout: [GridItem]
	
	private var thumbnailWidth: CGFloat = ViewSpecs.scaledSize(of: 60)
	
	// MARK: - Init
	init(items: [Merchant]) {
		self.items = items;
		
		// Setup Grid Layout
		let defaultGrid = GridItem(.fixed(gridItemHeight), spacing: itemSpacing, alignment: .top);
		gridLayout = [defaultGrid, defaultGrid];
	}
	
	// MARK: - Body
	var body: some View {
		LazyHGrid(rows: gridLayout) {
			ForEach(items, id: \.id) { item in
				NavigationLink {
					MerchantProductsView(merchant: item)
				} label: {
					MerchantItem(item: item,
								 width: gridItemWidth,
								 height: gridItemHeight,
								 thumbnailWidth: thumbnailWidth)
				}
			}
			.frame(maxWidth: .infinity)
		}
		.padding(.horizontal, ViewSpecs.leadingPadding)
	}
}
