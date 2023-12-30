//
//  TopMerchantProductsGridView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 16/09/2023.
//

import SwiftUI

struct TopMerchantProductsGridView: View {
	
	// MARK: - Data
	var items: [Product]
	
	// MARK: - View Specs
	private let leadingSpace: CGFloat = ViewSpecs.leadingPadding;
	private let trailingSpace: CGFloat = ViewSpecs.trailingPadding;
	
	private let itemSpacing: CGFloat = ViewSpecs.scaledSize(of: 6)
	private var gridItemWidth: CGFloat = ViewSpecs.scaledSize(of: 173)
	private var gridItemHeight: CGFloat = ViewSpecs.scaledSize(of: 273)
	private var gridLayout: [GridItem]
	
	// MARK: - Init
	init(items: [Product]) {
		self.items = items;
		
		// Setup Grid Layout
		let defaultGrid = GridItem(.fixed(gridItemHeight), spacing: itemSpacing);
		gridLayout = [defaultGrid];
	}
	
	// MARK: - Body
	var body: some View {
		LazyHGrid(rows: gridLayout) {
			ForEach(Array(items.enumerated()), id: \.offset) { index, item in
				NavigationLink {
					ProductDetailsView(productID: item.id,
									   product: item,
									   productName: item.name,
									   merchantID: item.sellerID ?? "",
									   subCategoryID: item.subCategoryID ?? 0)
				} label: {
					ProductsListItem(item: item)
						.frame(width: gridItemWidth)
				}
			}
			.frame(maxWidth: .infinity)
		}
		.padding(.horizontal, ViewSpecs.leadingPadding)
		.frame(height: gridItemHeight + 1)
	}
}
