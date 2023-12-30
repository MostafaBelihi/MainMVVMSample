//
//  ProductsListView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 08/08/2023.
//

import SwiftUI

struct ProductsListView: View {
	
	// MARK: - Data
	var items: [Product]
	var totalCount: Int

	// MARK: - Flags
	var contentStatus: ListContentStatus
	var loadingPhase: ViewDataLoadingPhase
	var dataLoadingInProgress: Bool

	// MARK: - Actions
	var onPaging: VoidClosure

	// MARK: - Empty Message
	var emptyMessage: String
	var emptyMessageActionButtonText: String?
	var emptyMessageActionButtonHandler: VoidClosure?

	// MARK: - View Specs
	private var gridLayout: [GridItem]
	private let itemsCountPerRow: CGFloat = 2;
	private let itemSpacing: CGFloat = !DeviceTrait.isPad ? 10 : 20;
	private var gridItemWidth: CGFloat
	private var gridItemHeight: CGFloat = !DeviceTrait.isPad ? 300 : 450
	
	// MARK: - Init
	init(items: [Product],
		 totalCount: Int,
		 contentStatus: ListContentStatus,
		 loadingPhase: ViewDataLoadingPhase,
		 dataLoadingInProgress: Bool,
		 onPaging: @escaping VoidClosure,
		 emptyMessage: String,
		 emptyMessageActionButtonText: String? = nil,
		 emptyMessageActionButtonHandler: VoidClosure? = nil
	) {
		self.items = items;
		self.totalCount = totalCount;
		self.contentStatus = contentStatus;
		self.loadingPhase = loadingPhase;
		self.dataLoadingInProgress = dataLoadingInProgress;
		self.onPaging = onPaging;
		self.emptyMessage = emptyMessage;
		self.emptyMessageActionButtonText = emptyMessageActionButtonText;
		self.emptyMessageActionButtonHandler = emptyMessageActionButtonHandler;

		// Setup Grid Layout
		let totalDeductedSpacingPerRow: CGFloat = (itemSpacing * (itemsCountPerRow - 1));	// spacing does not apply to last item per row
		gridItemWidth = ((UIScreen.main.bounds.width - ViewSpecs.leadingPadding - ViewSpecs.trailingPadding - totalDeductedSpacingPerRow) / itemsCountPerRow);
		let defaultGrid = GridItem(.fixed(gridItemWidth), spacing: itemSpacing, alignment: .top);
		gridLayout = [defaultGrid, defaultGrid];
	}

	// MARK: - Body
	var body: some View {
		switch contentStatus {
			case .initView:
				ProgressIndicator()
					.frame(maxHeight: .infinity)

			case .initList:
				if (dataLoadingInProgress) {
					ProgressIndicator()
						.frame(maxHeight: .infinity)
				}
				
			case .initSearch:
				Text(Localizables.initSearchList.text)
					.textBaseStyle()
					.frame(height: !DeviceTrait.isPad ? 300 : 450)
				
			case .emptyList:
				MessageView(mainMessage: emptyMessage,
							animationFileName: "Empty.json",
							width: UIScreen.main.bounds.width * 0.8, 
							actionButtonText: emptyMessageActionButtonText,
							actionButtonHandler: emptyMessageActionButtonHandler)
				
			case .fullList:
				ScrollView {
					VStack(spacing: 0) {
						LazyVGrid(columns: gridLayout, spacing: itemSpacing) {
							ForEach(Array(items.enumerated()), id: \.offset) { index, item in
								NavigationLink {
									ProductDetailsView(productID: item.id,
													   product: item,
													   productName: item.displayName,
													   merchantID: item.sellerID ?? "",
													   subCategoryID: item.subCategoryID ?? 0)
								} label: {
									ZStack(alignment: .bottom) {
										ProductsListItem(item: item)
										
										// Pagination
										if let lastItem = items.last {
											if (lastItem.id == item.id && items.count < totalCount) {
												Color.clear
													.frame(height: 0.05)
													.onAppear {
														onPaging()
													}
											}
										}
									}
									.frame(width: gridItemWidth, height: gridItemHeight)
								}
								.buttonStyle(PlainButtonStyle())
							}
							.frame(maxWidth: .infinity)
						}
						.padding(.vertical, 10)
						
						// Pagination
						if (dataLoadingInProgress && loadingPhase == .pagination) {
							ProgressView()
								.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
								.frame(height: 50)
						}
					}
				}
		}
	}
}
