//
//  HomeView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import SwiftUI

struct HomeView: View {
	
	// MARK: - Dependencies
	@EnvironmentObject private var presenter: HomePresenter
	@EnvironmentObject private var tabBarPresenter: TabBarPresenter
	@EnvironmentObject private var notificationViewHandler: NotificationViewHandler
	// SampleSimplification:: 
//	@EnvironmentObject private var cart: Cart
	@EnvironmentObject private var auth: Auth
	@EnvironmentObject private var storeManager: StoreManager
	@StateObject private var alertManager = AlertManager()
	
	// MARK: - View Specs
	// Top Header Behavior
	@State private var isExpanded = true
	@State private var scrollOffset: CGFloat = 0
	
	// Nav Flags
	@State private var showingSearchResults = false
	@State private var showingNotificationItem = false
	@State private var showingOrderGiftForm = false

	private func makeSectionHeading(_ text: String,
									@ViewBuilder additionalContent: (() -> some View) = { EmptyView() }) -> some View {
		HStack {
			Text(text)
			Spacer()
			additionalContent()
		}
		.homeSectionHeadingStyle()
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			ZStack {
				GeometryReader { geoGlobal in
					VStack(spacing: 0) {
						// MARK: - Header
						HomeHeader(searchQuery: $presenter.searchQuery,
								   barCode: $presenter.searchBarCode,
								   searchPlaceholder: isExpanded ? Localizables.placeholderSearch.text : Localizables.placeholderSearchShort.text,
								   searchPlaceholderCondition: presenter.searchQuery.isEmpty,
								   height: isExpanded ? ViewSpecs.searchBarHeightExpanded : ViewSpecs.searchBarHeightCompact,
								   isExpanded: isExpanded,
								   onDismissBarCode: {
							
							presenter.searchQuery = "";
							showingSearchResults = true;
						}, onSubmit: {
							presenter.searchBarCode = "";
							showingSearchResults = true
						})
						.animation(.default, value: isExpanded)
						
						// Scrollable Area
						ScrollView {
							VStack(spacing: ViewSpecs.scaledSize(of: 25)) {
								
								// MARK: - Merchant Types
								VStack(spacing: 15) {
									makeSectionHeading(Localizables.merchTypeHeader.text)
									ShopTypesGridView()
								}
								
								// MARK: - Carousel Banners
								Group {
									if (presenter.banners.count > 0) {
										ScrollingBannerView(banners: presenter.banners)
									}
									else {
										Group {
											ProgressView()
												.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
										}
										.frame(width: ViewSpecs.scaledSize(of: 303),
											   height: ViewSpecs.scaledSize(of: 120))
									}
								}
								
								// MARK: - Global Spinner
								if (presenter.isFetching) {
									ProgressView()
										.scaleEffect(ViewSpecs.scaledSize(of: 1.5))
										.frame(height: ViewSpecs.scaledSize(of: 120))
										.frame(maxWidth: .infinity)
								}
								
								// MARK: - Recommended Merchants
								if (presenter.recommendedMerchants.count > 0) {
									VStack(spacing: 15) {
										// Section Heading
										makeSectionHeading(Localizables.merchRecommendedHeader.text) {
											Button {
												tabBarPresenter.showAllMerchantsList();
											} label: {
												Text(Localizables.allMerchants.text)
													.underline()
													.homeSectionHeadingLinkStyle()
											}
										}
										
										// Data View
										if (presenter.recommendedMerchants.count <= 2) {
											// For iOS 15: This is to fix issue with iOS 15 with right-to-left hosrizontal scrolling
											HStack {
												RecommendedMerchantsGridView(items: presenter.recommendedMerchants)
												Spacer()
											}
										}
										else {
											ScrollViewReader { scrollView in
												ScrollView(.horizontal) {
													RecommendedMerchantsGridView(items: presenter.recommendedMerchants)
												}
												.onViewLoad {
													// For iOS 15: Horizontal scrolling with right-to-left direction does not sequence items in the right direction as expected
													if #available(iOS 16, *) {
														return;
													} else {
														scrollView.scrollTo(presenter.recommendedMerchants[presenter.recommendedMerchants.count - 1].id);
													}
												}
											}
										}
									}
								}
								
								// MARK: - Top Merchants Products
								VStack(spacing: ViewSpecs.scaledSize(of: 25)) {
									if (presenter.topMerchantProducts.count > 0) {
										ForEach(presenter.topMerchantProducts, id: \.id) { item in
											if item.products.count > 0 {
												VStack(spacing: 15) {
													// Section Heading
													makeSectionHeading(Localizables.merchTopProductsHeader.text.replacingOccurrences(of: "{name}", with: item.name)) {
														NavigationLink {
															MerchantProductsView(merchant: Merchant(id: item.id, name: item.name))
														} label: {
															Text(Localizables.allProducts.text)
																.underline()
																.homeSectionHeadingLinkStyle()
														}
													}
													
													// Data View
													if (!DeviceTrait.isPad && item.products.count <= 1) || (DeviceTrait.isPad && item.products.count <= 2) {
														// For iOS 15: This is to fix issue with iOS 15 with right-to-left hosrizontal scrolling
														HStack {
															TopMerchantProductsGridView(items: item.products)
															Spacer()
														}
													}
													else {
														ScrollViewReader { scrollView in
															ScrollView(.horizontal) {
																TopMerchantProductsGridView(items: item.products)
															}
															.onViewLoad {
																// For iOS 15: Horizontal scrolling with right-to-left direction does not sequence items in the right direction as expected
																if #available(iOS 16, *) {
																	return;
																} else {
																	scrollView.scrollTo(item.products.count - 1);
																}
															}
														}
													}
												}
											}
										}
									}
								}
								.padding(.bottom, 10)
								
								// MARK: - Special Navigation
								// SampleSimplification:: 
								// Search Results
//								NavigationLink("", destination: ProductsSearchResultsView(searchQuery: presenter.searchQuery,
//																						  barCode: presenter.searchBarCode),
//											   isActive: $showingSearchResults)
								
								// Notification View
								NavigationLink("", destination: ProductDetailsView(productID: notificationViewHandler.notificationItemID ?? 0,
																				   productName: "",
																				   merchantID: notificationViewHandler.data1 ?? "",
																				   subCategoryID: Int(notificationViewHandler.data2 ?? "") ?? 0),
											   isActive: $showingNotificationItem)
							}
							.padding(.top, ViewSpecs.scaledSize(of: 25))
							
							// MARK: - Scrolling Detector
							.background(
								GeometryReader {
									Color.clear.preference(
										key: ViewOffsetKey.self,
										value: -$0.frame(in: .named("scroll")).origin.y
									)
								}
							)
							.onPreferenceChange(ViewOffsetKey.self) { newOffset in
								if (newOffset >= 0) {
									if (newOffset != scrollOffset) {
										if (isExpanded && newOffset > scrollOffset) {
											isExpanded = false
										}
										
										if (!isExpanded && (newOffset >= 0 && newOffset <= 100)) {
											isExpanded = true
										}
									}
									
									scrollOffset = newOffset;
								}
							}
						}
						.coordinateSpace(name: "scroll")
					}
				}
				
				// SampleSimplification:: 
//				if (cart.isSubmitting) {
//					ProgressIndicator()
//				}
			}
			
			// MARK: - NavBar
			.navigationBarHidden(true)
			
			// MARK: - Sheets
			.sheet(isPresented: $showingOrderGiftForm) {
				HalfSheetView {
					// SampleSimplification:: 
//					OrderGiftCodeView()
				}
			}

			// MARK: - Events
			.onViewLoad {
				onViewLoad()
			}
			.onAppear {
				// Clear notification badge
				UIApplication.shared.applicationIconBadgeNumber = 0;
				
				handleAppUpdateCase()
			}
			.onDisappear {
				handleAppUpdateCase()
			}
			.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
				handleAppUpdateCase()
			}
			.onTapGesture {
				hideKeyboard()
			}
			.onChange(of: presenter.appPreLoadStatus, perform: { newValue in
				// Watch for change in AppPreLoadStatus if it's in progress. Only handles success and failure status because they come after inProgress status
				if (newValue == .succeeded || newValue == .failed) {
					presenter.handleAppPreLoad();
				}
			})
			.onChange(of: presenter.mustUpdateApp, perform: { _ in
				handleAppUpdateCase();
			})
			
			// MARK: - Alerts
			.advancedAlert(alertManager: alertManager)
			
		}
		.navigationViewStyle(.stack)
		
		// MARK: - Events
		.onChange(of: notificationViewHandler.didReceiveNewNotification, perform: { _ in
			if (notificationViewHandler.notificationItemType == .product) {
				guard Int(notificationViewHandler.data2 ?? "") != nil else {
					return;
				}
				
				// Show notification item
				showingNotificationItem = true;
			}
		})
		.onChange(of: storeManager.activeStore.id) { _ in
			onChangeStore()
		}
		.onChange(of: auth.isAuthenticated) { _ in
			onChangeAuth();
		}
		.onChange(of: presenter.triggeredAlert) { _ in
			onTriggerAlert()
		}
	}
	
	// MARK: - Events Handlers
	private func onViewLoad() {
		// Data
		presenter.loadData();
	}
	
	private func handleAppUpdateCase() {
		if (presenter.mustUpdateApp) {
			forceAppUpdate();
		}
	}
	
	private func onChangeStore() {
		presenter.reloadData();
	}
	
	private func onChangeAuth() {
		presenter.reloadData();
	}
	
	private func onTriggerAlert() {
		alertManager.showError(title: presenter.alertInfo.title,
							   message: presenter.alertInfo.message,
							   actionButtonText: presenter.alertInfo.actionButtonText,
							   handler: presenter.alertInfo.actionButtonHandler);
	}
	
}

// MARK: - Functions
extension HomeView {
	private func forceAppUpdate() {
		alertManager.showInfo(title: Localizables.mustUpdateAppTitle.text,
							  message: Localizables.mustUpdateAppMessage.text,
							  actionButtonText: Localizables.update.text) {
			browseAppStore();
		}
	}
	
	private func browseAppStore() {
		guard let url = URL(string: GlobalConstants.appStoreLink) else {
			alertManager.showInfo(title: Localizables.failTitle.text,
								  message: ErrorType.internalError.localizedMessage);
			return;
		}
		
		UIApplication.shared.open(url);
	}
}

// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.environmentObject(HomePresenter())
			.environmentObject(Auth())
			// SampleSimplification:: 
//			.environmentObject(Cart())
			.environmentObject(NotificationViewHandler())
			.environmentObject(StoreManager())	// this is needed for embedded subviews, not for this view
	}
}

struct ViewOffsetKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue = CGFloat.zero
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value += nextValue()
	}
}
