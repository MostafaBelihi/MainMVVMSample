//
//  ProductsListItem.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 07/08/2023.
//

import SwiftUI

struct ProductsListItem: View {
	
	// MARK: - Dependencies
	@StateObject private var presenter = ProductItemPresenter()
	// SampleSimplification:: 
//	@EnvironmentObject private var cart: Cart
	@StateObject private var alertManager = AlertManager()


	// MARK: - Inputs
	@State var item: Product?
	
	// MARK: - View Flags
	@State private var isSettingFavorite: Bool = false
	
	// MARK: - View Specs
	private let padding: CGFloat = ViewSpecs.scaledSize(of: 12)
	private let globalSpacing: CGFloat = ViewSpecs.scaledSize(of: 12)
	private let lineSpacing: CGFloat = ViewSpecs.scaledSize(of: 3)
	private let wordSpacing: CGFloat = ViewSpecs.scaledSize(of: 3)
	
	// MARK: - Body
	var body: some View {
		GeometryReader { geo in
			ZStack {
				// Shaded Box
				RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius)
					.fill(Color(ColorRGB(r: 251, g: 251, b: 251)))
					.overlay(
						RoundedRectangle(cornerRadius: ViewSpecs.globalCornerRadius)
							.stroke(Color(ColorRGB(r: 237, g: 237, b: 237)), lineWidth: 1)
					)
				
				// Item Content
				VStack(spacing: globalSpacing) {
					ZStack(alignment: .topLeading) {
						// Image
						VStack(spacing: 0) {
							AsyncImage(url: URL(string: presenter.imageURL ?? "")) { phase in
								if let image = phase.image {
									// Remote image
									image
										.resizable()
										.scaledToFit()
								}
								else if phase.error != nil {
									// Error
									Image(ImageNames.productPlaceholder)
										.resizable()
										.scaledToFit()
								}
								else {
									// Placeholder
									Image(ImageNames.productPlaceholder)
										.resizable()
										.scaledToFit()
								}
							}
						}
						.frame(height: geo.size.height * 0.509)
						.frame(maxWidth: .infinity)
						.padding(.top, padding)
						.padding(.horizontal, padding)
						.clipShape(Rectangle())
						
						// Favorite Button
						// TODO: I may encapsulate this button for all views
						// [Favorite]TODO: Return later -- Favorite
						//					VStack {
						//						Button(action: {
						//							isSettingFavorite = true
						//							onFavorite()
						//						}, label: {
						//							ZStack {
						//								if (favoriteDataInProgress && isSettingFavorite) {
						//									ProgressView()
						//										.scaleEffect(!DeviceTrait.isPad ? 1 : 1.5)
						//								}
						//								else {
						//									// TODO: Encapsulate the image or the style
						//									if (item.isFavorite) {
						//										Image(systemName: "heart.fill")
						//											.resizable()
						//											.scaledToFit()
						//											.foregroundColor(.tintPrimary)
						//									}
						//									else {
						//										Image(systemName: "heart")
						//											.resizable()
						//											.scaledToFit()
						//											.foregroundColor(.tintPrimary)
						//									}
						//								}
						//							}
						//							.frame(maxWidth: .infinity, maxHeight: .infinity)
						//						})
						//						.frame(width: !DeviceTrait.isPad ? 20 : 30, height: !DeviceTrait.isPad ? 20 : 30)
						//					}
						//					.padding(.top, 10)
						//					.padding(.leading, 10)
					}
					
					VStack(alignment: .leading, spacing: globalSpacing) {
						// Spacing set to 0 because the first filler will add unnecessary spacing before the first element. spacing is set using padding of inner elements.
						VStack(alignment: .leading, spacing: 0) {
							// TODO: If repeated, add a dedicated element for it
							// Full width filler to set text to the most leading point
							ViewElements.makeFullWidthFiller(fillColor: .clear, height: 0.001)
							
							// Name
							Text(presenter.name)
								.multilineTextAlignment(.leading)
								.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .bold).font)
							
							// Seller
							if let sellerName = presenter.sellerName {
								HStack(alignment: .lastTextBaseline, spacing: wordSpacing) {
									Text("\(Localizables.productSeller.text)")
										.multilineTextAlignment(.leading)
										.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .semibold).font)
									Text(sellerName)
										.multilineTextAlignment(.leading)
										.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .regular).font)
								}
								.padding(.top, lineSpacing)
							}
						}
						.foregroundColor(.textPrimary)
						.frame(height: geo.size.height * 0.117)
						.frame(maxWidth: .infinity)
						
						// Price
						if (presenter.isAvailable) {
							HStack(alignment: .lastTextBaseline, spacing: 2) {
								Text(presenter.price)
									.productsListPriceTextStyle(isLongNumber: presenter.price.count > 5)
								
								Text(presenter.currencyText)
									.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .semibold).font)
									.foregroundColor(.textPrimary)
								
								Spacer()
								
								if let originalPrice = presenter.originalPrice {
									DiscountedPriceTextView(originalPrice)
										.productsListDiscountedPriceTextStyle()
								}
							}
							.frame(height: geo.size.height * 0.055)
						}
						else {
							HStack(alignment: .bottom, spacing: 2) {
								Text(Localizables.unavailableProductPrice.text)
									.productsListUnavailablePriceTextStyle()
							}
							.frame(height: geo.size.height * 0.055)
						}
						
						// Add to Cart
						TintedButton(title: Localizables.addToCart.text,
									 height: geo.size.height * 0.099,
									 cornerRadius: ViewSpecs.scaledSize(of: 3),	// TODO: Add to ViewSpecs if needed for all buttons
									 font: AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .semibold).font,
									 disabled: !presenter.isAvailable,
									 inlineLeadingImage: Image(systemName: "plus.circle.fill"),
									 action: onAddToCart)
					}
					.padding(.horizontal, padding)
					.padding(.bottom, padding)
				}
			}
		}
		
		// MARK: - Alerts
		.advancedAlert(alertManager: alertManager)
		
		// MARK: - Events
		.onViewLoad {
			onViewLoad();
		}
		.onChange(of: presenter.triggeredAlert) { _ in
			onTriggerAlert()
		}
	}
	
	// MARK: - Events Handlers
	private func onViewLoad() {
		// Data
		presenter.config(product: item);
		self.item = nil;
	}
	private func onFavorite() {
//		presenter.setFavorite(productID: presenter.id, isFavorite: !presenter.isFavorite)
	}
	
	private func onAddToCart() {
		presenter.addToCart(item: presenter.item!);
	}
	
	private func onTriggerAlert() {
		alertManager.showError(title: presenter.alertInfo.title,
							   message: presenter.alertInfo.message,
							   actionButtonText: presenter.alertInfo.actionButtonText,
							   handler: presenter.alertInfo.actionButtonHandler);
	}
	
}
