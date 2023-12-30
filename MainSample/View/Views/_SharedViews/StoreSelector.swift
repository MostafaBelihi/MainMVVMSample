//
//  StoreSelector.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 03/08/2023.
//

import SwiftUI

struct StoreSelector: View {
	
	// MARK: - Inputs
	var viewFor: ViewMode = .header
	var isExpanded: Bool = false
	
	// MARK: - Dependencies
	@EnvironmentObject private var storeManager: StoreManager
	@StateObject private var alertManager = AlertManager()
	@EnvironmentObject private var notificationViewHandler: NotificationViewHandler

	// MARK: - View Specs
	// Nav Flags
	@State private var showingStorePicker = false

	// MARK: - Body
	var body: some View {
		ZStack {
			switch viewFor {
				case .header:
					// For general use in app header
					HStack(spacing: 5) {
						if let storeName = storeManager.activeStore?.name {
							Image("location-pin-2")
								.resizable()
								.scaledToFit()
								.frame(height: !DeviceTrait.isPad ? 18 : 18 * ViewSpecs.ipadScalingRatio)
							
							if (isExpanded) {
								Text(storeName)
									.foregroundColor(.white)
									.font(AppFont(size: TextStyle.small.fontSize, weight: .bold).font)
									.textBaseStyle()
							}
							
							ZStack {
								if (!storeManager.isFetching) {
									Image("arrow-head-down")
										.resizable()
										.scaledToFit()
										.frame(width: ViewSpecs.scaledSize(of: 13.333), height: ViewSpecs.scaledSize(of: 8))
										.foregroundColor(.white)
								}
								else {
									ProgressView()
										.progressViewStyle(CircularProgressViewStyle(tint: .white))
										.scaleEffect(ViewSpecs.scaledSize(of: 0.75))
										.frame(width: ViewSpecs.scaledSize(of: 13.333), height: ViewSpecs.scaledSize(of: 8))
								}
							}
						}
						else {
							Spacer()
						}
					}
					.padding(.vertical, !DeviceTrait.isPad ? 12 : 12 * ViewSpecs.ipadScalingRatio)
					.padding(.horizontal, !DeviceTrait.isPad ? 16 : 16 * ViewSpecs.ipadScalingRatio)
//					.frame(height: ViewSpecs.searchTextFieldHeight)
					.background(.backgroundTinted2)
					.clipShape(RoundedRectangle(cornerRadius: !DeviceTrait.isPad ? 67 : 67 * ViewSpecs.ipadScalingRatio))
					.onTapGesture {
						pickStore()
					}
				
				case .profileView:
					// For the ProfileView
					VStack(alignment: .leading, spacing: 13) {
						// Action
						Button {
							pickStore()
						} label: {
							ProfileViewItem(text: "\(Localizables.selecteStore.text) - \(storeManager.activeStore?.name ?? "")",
											icon: "store-selector", showingOperationIndicator: storeManager.isFetching)
						}
						
						// Separator Line
						ViewElements.verticalLineSeparator
					}
			}
		}
		
		// MARK: - Alerts
		.advancedAlert(alertManager: alertManager)

		// Store Picker
		.alert(Localizables.storePickerTitle.text, isPresented: $showingStorePicker) {
			if let stores = storeManager.stores {
				ForEach(stores, id: \.uniqueID) { item in
					Button(item.name, action: {
						changeActiveStore(item)
					})
				}
				
				Button(Localizables.cancel.text, role: .cancel, action: {})
			}
		} message: {
			Text(Localizables.storePickerMessage.text)
		}

		// MARK: - Events
		.onChange(of: notificationViewHandler.didReceiveNewNotification, perform: { _ in
			if (notificationViewHandler.notificationItemType == .product) {
				// Make sure any sheets are dismissed
				showingStorePicker = false;
			}
		})
    }
}

// MARK: - Data
extension StoreSelector {
	private func pickStore() {
		Task {
			// Fetch
			let result = await storeManager.loadStores();
			
			// There is an active submit
			guard let result = result else { return }
			
			//- Error Handling
			guard result.succeeded else {
				alertManager.showInfo(title: ErrorType.unknownError.getLocalizedMessage(withKeySuffix: Localizables.titlePostfix.rawValue),
									  message: "\(ErrorType.unknownError.localizedMessage) \(ErrorType.unknownError.getLocalizedMessage(withKeySuffix: Localizables.retryPostfix.rawValue))");
				return;
			}
			
			// Success, proceed
			showingStorePicker = true;
		}
	}
	
	private func changeActiveStore(_ store: Store) {
		storeManager.changeActiveStore(store);
	}
}

// MARK: - Embedded Types
extension StoreSelector {
	enum ViewMode {
		case header
		case profileView
	}
}
