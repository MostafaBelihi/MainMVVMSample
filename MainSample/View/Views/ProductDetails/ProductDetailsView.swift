//
//  ProductDetailsView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 13/04/2023.
//

import SwiftUI

struct ProductDetailsView: View {
	
	// MARK: - Inputs
	var productID: Int
	@State var product: Product?
	var productName: String
	var merchantID: String
	var subCategoryID: Int
	
	// MARK: - Dependencies
	@StateObject private var presenter = ProductDetailsPresenter();
	@EnvironmentObject private var auth: Auth
	@EnvironmentObject private var storeManager: StoreManager
	// SampleSimplification:: 
//	@EnvironmentObject private var cart: Cart
	@StateObject private var alertManager = AlertManager()
	
	// MARK: - More Variables
	
	
	// MARK: - View Specs
	@Environment(\.dismiss) var dismiss
	@FocusState var quantityInputFocused: Bool
	var quantityButtonHeight: CGFloat = !DeviceTrait.isPad ? 45 : 67.5
	private let lineSpacing: CGFloat = ViewSpecs.scaledSize(of: 7)
	private let wordSpacing: CGFloat = ViewSpecs.scaledSize(of: 5)

	// MARK: - Body
	var body: some View {
		GeometryReader { geo in
			if presenter.item != nil {
				ZStack {
					VStack(spacing: 0) {
						// NavBar extension
						ViewElements.navBarExtension
						
						// MARK: - Main Info Box
						VStack(spacing: 0) {
							// Item Content
							VStack(spacing: 25) {
								ZStack(alignment: .topLeading) {
									// Image
									VStack {
										// TODO: Encapsulate all AsyncImages
										AsyncImage(url: URL(string: presenter.imageURL ?? "")) { phase in
											if let image = phase.image {
												// Remote image
												image
													.resizable()
											}
											else if phase.error != nil {
												// Error
												Image(ImageNames.productPlaceholder)
													.resizable()
											}
											else {
												// Placeholder
												ProgressView()
													.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
													.frame(width: 200, height: 200)
											}
										}
										.scaledToFit()
										.padding(.top, 20)
										.frame(height: geo.size.height * 0.35)
										.clipShape(Rectangle())
									}
									.frame(maxWidth: .infinity)
									
									// Favorite Button
									// [Favorite]TODO: Return later -- Favorite
//									VStack {
//										Button(action: {
//											onFavorite()
//										}, label: {
//											ZStack {
//												if (presenter.isSubmitting) {
//													ProgressView()
//														.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
//												}
//												else {
//													// TODO: Encapsulate the image or the style
//													if (presenter.isFavorite) {
//														Image(systemName: "heart.fill")
//															.resizable()
//															.scaledToFit()
//															.foregroundColor(.tintPrimary)
//													}
//													else {
//														Image(systemName: "heart")
//															.resizable()
//															.scaledToFit()
//															.foregroundColor(.tintPrimary)
//													}
//												}
//											}
//											.frame(maxWidth: .infinity, maxHeight: .infinity)
//										})
//										.frame(width: !DeviceTrait.isPad ? 30 : 45, height: !DeviceTrait.isPad ? 30 : 45)
//									}
//									.padding(.top, 20)
//									.padding(.leading, 10)
								}
								
								VStack(alignment: .leading, spacing: 25) {
									VStack(alignment: .leading, spacing: 0) {
										// Name
										Text(presenter.name)
											.multilineTextAlignment(.leading)
											.foregroundColor(.textPrimary)
											.productDetailsNameTextStyle()
										
										// Seller
										if let sellerName = presenter.sellerName {
											HStack(alignment: .lastTextBaseline, spacing: wordSpacing) {
												Text("\(Localizables.productSeller.text)")
													.multilineTextAlignment(.leading)
													.font(AppFont(size: ViewSpecs.scaledSize(of: 20), weight: .semibold).font)
												Text(sellerName)
													.multilineTextAlignment(.leading)
													.font(AppFont(size: ViewSpecs.scaledSize(of: 20), weight: .regular).font)
											}
											.padding(.top, lineSpacing)
										}
									}

									// Price
									if (presenter.isAvailable) {
										HStack(alignment: .lastTextBaseline, spacing: 2) {
											Text(presenter.price)
												.productDetailsPriceTextStyle()
											
											Text(Localizables.egp.text)
												.font(AppFont(size: TextStyle.normal.fontSize, weight: .semibold).font)
											
											Spacer()
											
											if let originalPrice = presenter.originalPrice {
												DiscountedPriceTextView(originalPrice)
													.productDetailsDiscountedPriceTextStyle()
											}
										}
									}
									else {
										HStack(alignment: .lastTextBaseline, spacing: 2) {
											Text(Localizables.unavailableProductPrice.text)
												.productDetailsUnavailablePriceTextStyle()
										}
									}
									
									// Quantity
									HStack(alignment: .center, spacing: 5) {
										Button {
											onPlusQuantity()
										} label: {
											Image(systemName: "plus")
												.frame(width: quantityButtonHeight, height: quantityButtonHeight)
												.secondaryButtonStyle(cornerRadius: ViewSpecs.globalCornerRadius, disabled: !presenter.isAvailable)
										}
										.disabled(!presenter.isAvailable)
										
										// In early releases, this was TextField setting quantity, but replaced with Text upon requirements by the client
										Text(presenter.quantityText)
											.multilineTextAlignment(.center)
											.font(AppFont(size: TextStyle.large.fontSize, weight: .regular).font)
											.foregroundColor(.tintPrimary)
											.frame(height: quantityButtonHeight)
											.frame(maxWidth: .infinity)
											.background(.lightGray3)
											.overlay(
												RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius)
													.stroke(.lightGray3, lineWidth: 1)
											)
										
										Button {
											onMinusQuantity()
										} label: {
											Image(systemName: "minus")
												.frame(width: quantityButtonHeight, height: quantityButtonHeight)
												.secondaryButtonStyle(cornerRadius: ViewSpecs.globalCornerRadius, disabled: !presenter.isAvailable)
										}
										.disabled(!presenter.isAvailable)
									}
								}
								.padding(.horizontal, 10)
							}
							
							Spacer()
							
							// Add to Cart
							TintedButton(title: presenter.quantityInCart == 0 ? Localizables.addToCart.text : Localizables.updateCart.text,
										 height: ViewSpecs.mainButtonHeight,
										 cornerRadius: ViewSpecs.globalCornerRadius,
										 disabled: !presenter.isAvailable) {
								
								onAddToCart()
							}
						}
						.frame(width: geo.size.width * 0.8)
						.padding(.bottom, 20)
					}
					
					// SampleSimplification:: 
//					if (cart.isSubmitting) {
//						ProgressIndicator()
//					}
				}
			}
		}
		
		// MARK: - NavBar
		.navigationBarBackButtonHidden(true)
		.tintedNavBarStyle()
		.toolbar(content: {
			ToolbarItem(placement: .principal) {
				// Show title
				Text(productName)
					.tintedNavBarTitleStyle()
			}
			
			ToolbarItem(placement: .navigationBarLeading) {
				// TODO: I may encapsulate similar buttons
				Button {
					dismiss()
				} label: {
					Image(systemName: "control").tint(.black)
						.rotationEffect(Angle(degrees: -90))
				}
				.foregroundColor(.white)
			}
		})
		
		// MARK: - Alerts
		.advancedAlert(alertManager: alertManager)
		
		// MARK: - Events
		.onViewLoad {
			onViewLoad();
		}
		.onTapGesture {
			hideKeyboard()
		}
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
		presenter.config(productID: productID, product: product, merchantID: merchantID, subCategoryID: subCategoryID);
		self.product = nil;
		presenter.loadData();
	}
	
	private func onPlusQuantity() {
		presenter.incrementQuantity();
	}
	
	private func onMinusQuantity() {
		presenter.decrementQuantity();
	}
	
	private func onFavorite() {
		presenter.setFavorite(productID: presenter.id, isFavorite: !presenter.isFavorite)
	}
	
	private func onAddToCart() {
		// Add
		presenter.addToCart(item: presenter.item!, quantity: Double(presenter.quantity));
	}
	
	private func onChangeStore() {
		dismiss();
	}
	
	private func onChangeAuth() {
		dismiss();
	}
	
	private func onTriggerAlert() {
		alertManager.showError(title: presenter.alertInfo.title,
							   message: presenter.alertInfo.message,
							   actionButtonText: presenter.alertInfo.actionButtonText,
							   handler: presenter.alertInfo.actionButtonHandler);
	}
	
}

// MARK: - Previews
struct ProductDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		ProductDetailsView(productID: 4083,
						   productName: "دقيق فاخر الحاوي 1 كيلو تقريبا",
						   merchantID: "f8c8d90e-42dc-442e-8048-596a581eb394",
						   subCategoryID: 43)
		.environmentObject(Auth())
		.environmentObject(StoreManager())
		// SampleSimplification:: 
//		.environmentObject(Cart())
	}
}
