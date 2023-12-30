//
//  MerchantCategoriesHorizontalGridView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 07/08/2023.
//

import SwiftUI

struct MerchantCategoriesHorizontalGridView: View {
	
	// MARK: - Data
	@State var items: [Category]
	var selectedItem: Category?	// by ID
	
	// MARK: - Actions
	var onChangeSelectedItem: (_ newItem: Category?) -> Void

	// MARK: - View Specs
	private let leadingSpace: CGFloat = ViewSpecs.leadingPadding;
	private let trailingSpace: CGFloat = ViewSpecs.trailingPadding;

	private let itemSpacing: CGFloat = ViewSpecs.scaledSize(of: 16)
	private var gridItemHeight: CGFloat = ViewSpecs.scaledSize(of: 22)
	private var gridLayout: [GridItem]

	// MARK: - Init
	init(items: [Category], selectedItem: Category?, onChangeSelectedItem: @escaping (_ newItem: Category?) -> Void) {
		self.items = items;
		self.selectedItem = selectedItem;
		self.onChangeSelectedItem = onChangeSelectedItem;
		
		// Setup Grid Layout
		let defaultGrid = GridItem(.fixed(gridItemHeight), spacing: itemSpacing, alignment: .top);
		gridLayout = [defaultGrid];
	}

	// MARK: - Body
    var body: some View {
		if (items.count > 0) {
			ScrollViewReader { scrollView in
				ScrollView(.horizontal) {
					VStack(spacing: 0) {
						LazyHGrid(rows: gridLayout) {
							MerchantCategoriesHorizontalGridViewItem(name: "🔥 \(Localizables.metchantCategoryOffers.text)",
																	 selectedItemID: selectedItem?.id,
																	 height: gridItemHeight)
							.padding(.leading, leadingSpace)
							.onTapGesture {
								onChangeSelectedItem(nil)
							}

							ForEach(items, id: \.id) { item in
								MerchantCategoriesHorizontalGridViewItem(id: item.id,
																		 name: item.name,
																		 selectedItemID: selectedItem?.id,
																		 height: gridItemHeight)
								.padding(.trailing, items.last!.id == item.id ? trailingSpace : 0)
								.onTapGesture {
									onChangeSelectedItem(item)
								}
							}
						}
					}
					.frame(height: gridItemHeight)
					.padding(.vertical, ViewSpecs.scaledSize(of: 5))
				}
				.onViewLoad {
					// For iOS 15: Horizontal scrolling with right-to-left direction does not sequence items in the right direction as expected
					if #available(iOS 16, *) {
						return;
					} else {
						scrollView.scrollTo(items[items.count - 1].id, anchor: .trailing);
					}
				}
			}
		}
    }
}
