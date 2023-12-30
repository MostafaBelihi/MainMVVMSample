//
//  TabBarView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 27/02/2023.
//

import SwiftUI

struct TabBarView: View {

	// MARK: - Dependencies
	@StateObject private var presenter = HomePresenter()
	@StateObject private var tabBarPresenter = TabBarPresenter()
	@Inject var notificationManager: PNotificationManager
	
	// MARK: - Global Actors
	@StateObject private var storeManager = StoreManager()
	@StateObject private var auth = Auth()
	// SampleSimplification:: 
//	@StateObject private var cart = Cart()
	@StateObject private var settings = Settings()
	@StateObject private var notificationViewHandler = NotificationViewHandler()

	// MARK: - More Variable

	
	// MARK: - Body
	var body: some View {
		VStack(spacing: 0) {
			// Startup logo animation
			if (tabBarPresenter.isAnimating) {
				LaunchScreenView() { animationFinished in
					if (animationFinished) {
						withAnimation {
							tabBarPresenter.isAnimating = false
						}
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			
			// Main screen UI (TabBar)
			if (!tabBarPresenter.isAnimating) {
				TabView(selection: $tabBarPresenter.tabSelection) {
					HomeView()
						.tabItem {
							Image(tabBarPresenter.tabSelection == Tab.home.rawValue ? Tab.home.tabImageSelected : Tab.home.tabImage)
							Text(Tab.home.localizedName)
						}
						.tag(Tab.home.rawValue)
					
					// SampleSimplification:: 
//					CartView()
//						.tabItem {
//							Image(tabBarPresenter.tabSelection == Tab.cart.rawValue ? Tab.cart.tabImageSelected : Tab.cart.tabImage)
//							Text(Tab.cart.localizedName)
//						}
//						.tag(Tab.cart.rawValue)
//						.badge(Int(cart.totalQuantities))
//					
//					AllMerchantsView(selectedShopType: $tabBarPresenter.merchantsListSelectedShopType)
//						.tabItem {
//							Image(tabBarPresenter.tabSelection == Tab.merchants.rawValue ? Tab.merchants.tabImageSelected : Tab.merchants.tabImage)
//							Text(Tab.merchants.localizedName)
//						}
//						.tag(Tab.merchants.rawValue)

					ProfileView()
						.tabItem {
							Image(tabBarPresenter.tabSelection == Tab.profile.rawValue ? Tab.profile.tabImageSelected : Tab.profile.tabImage)
							Text(Tab.profile.localizedName)
						}
						.tag(Tab.profile.rawValue)
				}
				.onViewLoad() {
					onTabBarViewLoad()
				}
			}
		}
		
		.preferredColorScheme(.light)
		
		.environmentObject(presenter)
		.environmentObject(tabBarPresenter)
		.environmentObject(storeManager)
		.environmentObject(auth)
		// SampleSimplification:: 
//		.environmentObject(cart)
		.environmentObject(settings)
		.environmentObject(notificationViewHandler)
		
		.onViewLoad() {
			tabBarPresenter.tabSelection = Tab.home.rawValue;
			onViewLoad();
		}
		.onAppear() {
			onViewAppear();
		}
		
		.onChange(of: auth.isAuthenticated, perform: { _ in
			onAuthChange()
		})
		
		.onChange(of: notificationViewHandler.didReceiveNewNotification, perform: { _ in
			guard let notificationItemType = notificationViewHandler.notificationItemType else { return }
			
			// Switch to the suitable tab
			switch notificationItemType {
				case .product:
					tabBarPresenter.tabSelection = Tab.home.rawValue;
				case .order:
					tabBarPresenter.tabSelection = Tab.profile.rawValue;
			}
		})
	}
	
	// MARK: - Events Handlers
	private func onViewLoad() {
		presenter.config(settings: settings);

		// Add Global Actors to DI
		// SampleSimplification:: 
//		DependencyInjector.shared.cart = cart;
		DependencyInjector.shared.settings = settings;
		DependencyInjector.shared.auth = auth;

		// Handle notification payloads
		notificationManager.delegate = notificationViewHandler;
		
		// Load home data while animation is active
		presenter.preloadHomeData();
	}
	
	private func onTabBarViewLoad() {
		// Fire notification handlers after finishing app launch
		notificationManager.finishProcessingNotificationPayload();
		notificationViewHandler.didFinishAppLaunch = true;
	}
	
	private func onViewAppear() {
		
	}
	
	private func onAuthChange() {
		if (auth.isAuthenticated) {
			// SampleSimplification:: 
//			cart.initCart();
		}
		else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				// SampleSimplification:: 
//				cart.resetCart();
			}
		}
	}
}

// MARK: - Previews
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
			.preferredColorScheme(.dark)
    }
}
