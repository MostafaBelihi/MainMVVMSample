//
//  MerchantProductsView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 03/04/2023.
//

import SwiftUI

struct MerchantProductsView: View {

	// MARK: - Inputs
	var merchant: Merchant

	// MARK: - Dependencies
	@StateObject private var presenter = MerchantProductsPresenter()
	@EnvironmentObject private var auth: Auth
	@EnvironmentObject private var storeManager: StoreManager
	// SampleSimplification:: 
//	@EnvironmentObject private var cart: Cart
	@StateObject private var alertManager = AlertManager()

	// MARK: - More Variables


	// MARK: - View Specs
	@Environment(\.dismiss) var dismiss
	
	let profileImageSize: CGFloat = ViewSpecs.scaledSize(of: 68)
	let backButtonSize: CGFloat = ViewSpecs.scaledSize(of: 24)
	let globalPadding: CGFloat = ViewSpecs.scaledSize(of: 19)

	// MARK: - Body
    var body: some View {
		ZStack {
			GeometryReader { geoGlobal in
				VStack(spacing: 0) {
					// MARK: - Header
					VStack(spacing: 10) {
						Rectangle()
							.fill(.backgroundTinted)
							.frame(height: 0.0001)
						
						HStack(alignment: .top, spacing: ViewSpecs.scaledSize(of: 12)) {
							// Back Button
							Button {
								dismiss()
							} label: {
								Image("back")
									.resizable()
									.frame(width: backButtonSize, height: backButtonSize)
									.padding(.top, ViewSpecs.scaledSize(of: 14))
							}
							.foregroundColor(.white)
							
							if (presenter.item != nil) {
								// Thumbnail Image
								AsyncImage(url: URL(string: presenter.imageURL ?? "")) { phase in
									if let image = phase.image {
										// Remote image
										image
											.resizable()
									}
									else if phase.error != nil {
										// Error
										Image(ImageNames.userPlaceholder)
											.resizable()
									}
									else {
										// Placeholder
										ProgressView()
											.progressViewStyle(CircularProgressViewStyle(tint: .white))
											.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
											.frame(width: profileImageSize, height: profileImageSize)
									}
								}
								.scaledToFit()
								.frame(width: profileImageSize, height: profileImageSize)
								.clipShape(RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius))
								
								// Info
								VStack(alignment: .leading, spacing: 4) {
									ViewElements.makeFullWidthFiller(fillColor: .clear, height: ViewSpecs.scaledSize(of: 5))
									
									// Name
									Text(presenter.name)
										.merchantsDetailsNameStyle()
									
									HStack(alignment: .top, spacing: ViewSpecs.scaledSize(of: 14)) {
										VStack(alignment: .leading, spacing: ViewSpecs.scaledSize(of: 4)) {
											// Supported Shops Types
											if let supportedShopTypes = presenter.supportedShopTypes {
												Text(supportedShopTypes)
													.merchantsDetailsOtherInfoStyle()
											}
											
											// Address
											if let address = presenter.address {
												HStack(spacing: ViewSpecs.scaledSize(of: 4)) {
													Image("location-tiny")
														.foregroundColor(.white)
													
													Text(address)
														.merchantsDetailsOtherInfoStyle()
												}
											}
											
											// DeliveryCost
											if let deliveryCost = presenter.deliveryCost {
												HStack(spacing: ViewSpecs.scaledSize(of: 4)) {
													Image("delivery-motor")
													
													Text(deliveryCost)
														.merchantsDetailsOtherInfoStyle()
												}
											}
										}
										
										VStack(alignment: .leading, spacing: ViewSpecs.scaledSize(of: 4)) {
											// ShippingMethod
											if let shippingMethod = presenter.shippingMethod {
												Text(shippingMethod)
													.merchantsDetailsOtherInfoStyle()
											}
											
											// DeliveryDuration
											if let deliveryDuration = presenter.deliveryDuration {
												ViewElements.buildMerchantDeliveryDuration(durationText: deliveryDuration)
											}
										}
									}
								}
								.frame(maxWidth: .infinity)
							}
							else {
								Spacer()
							}
						}
						.frame(maxWidth: .infinity)
					}
					.frame(height: ViewSpecs.scaledSize(of: 86))
					.padding(.horizontal, globalPadding)
					.padding(.bottom, 10)
					.background(.backgroundTinted)
					
					// MARK: - Categories
					if (presenter.categories.count > 0) {
						MerchantCategoriesHorizontalGridView(items: presenter.categories,
															 selectedItem: presenter.selectedCategory) { newItem in
							onChangeCategory(to: newItem)
						}
						
						// MARK: - Products List
						HStack {
							Text(presenter.selectedCategoryName)
								.foregroundColor(.textPrimary)
								.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .bold).font)
							Spacer()
						}
						.padding(.leading, globalPadding)
						.padding(.vertical, 10)
					}
					
					ProductsListView(
						items: presenter.items,
						totalCount: presenter.totalCount,
						contentStatus: presenter.contentStatus,
						loadingPhase: presenter.loadingPhase,
						dataLoadingInProgress: presenter.isFetching,
						onPaging: {
							onPaging()
						},
						emptyMessage: Localizables.emptyProductsList.text
					)
				}
				.background(.backgroundPrimary)
			}
			
			// SampleSimplification:: 
//			if (cart.isSubmitting) {
//				ProgressIndicator()
//			}
		}

		// MARK: - NavBar
		.navigationBarHidden(true)

		// MARK: - Alerts
		.advancedAlert(alertManager: alertManager)

		// MARK: - Events
		.onViewLoad {
			onViewLoad();
		}
		.onAppear {
			// Clear notification badge
			UIApplication.shared.applicationIconBadgeNumber = 0;
		}
		.onTapGesture {
			hideKeyboard()
		}
		.onChange(of: storeManager.activeStore.id) { _ in
			onChangeStore()
		}
		.onChange(of: auth.isAuthenticated) { _ in
			onChangeAuth()
		}
		.onChange(of: presenter.triggeredAlert) { _ in
			onTriggerAlert()
		}
    }

	// MARK: - Events Handlers
	private func onViewLoad() {
		presenter.config(merchant: merchant);

		// This delay fixes an issue with the animation of navigating between the views
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
			presenter.loadData(for: .initLoad);
		}
	}

	private func onPaging() {
		presenter.loadData(for: .pagination);
	}

	private func onReload() {
		presenter.loadData(for: .reload);
	}

	private func onChangeCategory(to newItem: Category?) {
		presenter.changeSelectedCategory(to: newItem);
		presenter.loadData(for: .initLoad);
	}

	private func onChangeStore() {
		presenter.loadData(for: .initLoad);
	}

	private func onChangeAuth() {
		presenter.loadData(for: .initLoad);
	}

	private func onTriggerAlert() {
		alertManager.showError(title: presenter.alertInfo.title,
							   message: presenter.alertInfo.message,
							   actionButtonText: presenter.alertInfo.actionButtonText,
							   handler: presenter.alertInfo.actionButtonHandler);
	}
}

struct MerchantProductsView_Previews: PreviewProvider {
	static var previews: some View {
		MerchantProductsView(merchant: Merchant(id: "f8c8d90e-42dc-442e-8048-596a581eb394", name: "MainSampleMart"))
			.environmentObject(StoreManager())
			.environmentObject(Auth())
			// SampleSimplification:: 
//			.environmentObject(Cart())
	}
}
