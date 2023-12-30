//
//  ShopTypesGridView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 11/09/2023.
//

import SwiftUI

struct ShopTypesGridView: View {
	
	// MARK: - Dependencies
	@EnvironmentObject private var tabBarPresenter: TabBarPresenter

	// MARK: - Data
	var items = ShopType.allCases

	// MARK: - View Specs
	private let leadingSpace: CGFloat = ViewSpecs.leadingPadding;
	private let trailingSpace: CGFloat = ViewSpecs.trailingPadding;

	private let itemsCountPerRow: CGFloat = 4;
	private let itemSpacing: CGFloat = !DeviceTrait.isPad ? 10 : 20;
	private var gridItemWidth: CGFloat
	private var gridLayout: [GridItem]

	// MARK: - Init
	init() {
		// Setup Grid Layout
		let totalDeductedSpacingPerRow: CGFloat = (itemSpacing * (itemsCountPerRow - 1));	// spacing does not apply to last item per row
		gridItemWidth = ((UIScreen.main.bounds.width - leadingSpace - trailingSpace - totalDeductedSpacingPerRow) / itemsCountPerRow);
		let defaultGrid = GridItem(.fixed(gridItemWidth), spacing: itemSpacing, alignment: .top);
		gridLayout = [defaultGrid, defaultGrid, defaultGrid, defaultGrid];
	}

	// MARK: - Body
	var body: some View {
		LazyVGrid(columns: gridLayout) {
			ForEach(Array(items.enumerated()), id: \.offset) { index, item in
				// Shop Type
				ZStack {
					RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius)
						.fill(.merchantTypesBackground)
					
					VStack {
						Spacer()
						Image(item.imageString)
							.resizable()
							.scaledToFit()
							.clipShape(RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius))
					}
					
					VStack {
						Text(item.rawValue.localized)
							.foregroundColor(.tintSecondary)
							.font(AppFont(size: !DeviceTrait.isPad ? 8 : 15, weight: .semibold).font)
							.multilineTextAlignment(.center)
							.padding(.horizontal, !DeviceTrait.isPad ? 5 : 5 * ViewSpecs.ipadScalingRatio)
							.padding(.top, !DeviceTrait.isPad ? 10 : 20)
						Spacer()
					}
					
				}
				.frame(width: gridItemWidth, height: gridItemWidth)
				.onTapGesture {
					tabBarPresenter.showAllMerchantsList(with: item);
				}
			}
			.frame(maxWidth: .infinity)

			// All Items
			ZStack {
				RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius)
					.fill(.yellowSpecial)
				
				VStack {
					Spacer()
					Image("merch-all")
						.resizable()
						.scaledToFit()
						.clipShape(RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius))
				}

				VStack {
					Text(Localizables.allMerchants.text)
						.foregroundColor(.tintPrimary)
						.font(AppFont(size: !DeviceTrait.isPad ? 8 : 15, weight: .semibold).font)
						.padding(.horizontal, !DeviceTrait.isPad ? 5 : 5 * ViewSpecs.ipadScalingRatio)
						.padding(.top, !DeviceTrait.isPad ? 10 : 20)
					Spacer()
				}
				
			}
			.frame(width: gridItemWidth, height: gridItemWidth)
			.onTapGesture {
				tabBarPresenter.showAllMerchantsList();
			}
		}
	}
}
