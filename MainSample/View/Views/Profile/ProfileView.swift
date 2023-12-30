//
//  ProfileView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 27/02/2023.
//

import SwiftUI

struct ProfileView: View {
	
	// MARK: - Dependencies
	@StateObject private var presenter = ProfilePresenter()
	@EnvironmentObject private var auth: Auth
	@EnvironmentObject private var notificationViewHandler: NotificationViewHandler
	@EnvironmentObject private var settings: Settings
	@StateObject private var alertManager = AlertManager()

	// MARK: - View Specs
	@State private var showingLogin = false
	@State private var showingRegister = false
	@State private var showingStorePicker = false
	@State private var showingPrivacyPolicy = false
	@State private var showingReturnPolicy = false
	@State private var showingNotificationItem = false

	// MARK: - Body
	var body: some View {
		NavigationView {
			ZStack {
				GeometryReader { geoGlobal in
					ScrollView {
						VStack(spacing: 0) {
							// NavBar extension - Not big, but required to preserve dimensions of objects below it
							Rectangle()
								.fill(auth.isAuthenticated ? .backgroundTinted : .backgroundPrimary)
								.frame(height: 1)
							
							// MARK: - User Info
							if (auth.isAuthenticated) {
								VStack {
									HStack(spacing: 15) {
										Image(systemName: "person.circle.fill")
											.resizable()
											.scaledToFit()
											.frame(width: 70)
											.clipShape(Circle())
											.foregroundColor(.white)
										
										VStack(alignment: .leading, spacing: 10) {
											Text(auth.name ?? "")
												.foregroundColor(.white)
												.smallTextStyle()
											Text(auth.userEmail ?? "")
												.foregroundColor(.white)
												.smallTextStyle()
										}

										Spacer()

										// User Wallet
										if let userWallet = settings.appSettings?.userWalletText {
											VStack(spacing: 10) {
												Text(Localizables.userWallet.text)
												
												VStack {
													Text(userWallet)
														.foregroundColor(.tintPrimary)
												}
												.frame(width: ViewSpecs.scaledSize(of: 93), height: ViewSpecs.scaledSize(of: 28))
												.background(.white)
												.clipShape(RoundedRectangle(cornerRadius: ViewSpecs.scaledSize(of: 28) / 2))
											}
											.foregroundColor(.white)
											.font(AppFont(size: ViewSpecs.scaledSize(of: 10), weight: .bold).font)
										}
									}
									.padding(20)
								}
								.frame(maxWidth: .infinity)
								.background(.backgroundTinted)
							}
							
							VStack(spacing: 30) {
								// MARK: - Profile Options
								VStack(spacing: 20) {
									// Store Selector
									StoreSelector(viewFor: .profileView)

									if (!auth.isAuthenticated) {
										// Menu Item: Login
										VStack(alignment: .leading, spacing: 15) {
											NavigationLink(destination: LoginView(), isActive: $showingLogin) {
												ProfileViewItem(text: Localizables.login.text, icon: "person")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
										
										// Menu Item: Register
										VStack(alignment: .leading, spacing: 15) {
											// SampleSimplification:: Views that were removed from the project were replaced with EmptyView
											NavigationLink(destination: EmptyView(), isActive: $showingRegister) {
												ProfileViewItem(text: Localizables.register.text, icon: "person")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
									}
									
									// Menu Item: Orders
									if (auth.isAuthenticated) {
										VStack(alignment: .leading, spacing: 15) {
											// SampleSimplification:: Views that were removed from the project were replaced with EmptyView
											NavigationLink(destination: EmptyView()) {
												ProfileViewItem(text: Localizables.orders.text,
															 icon: "orders")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
									}
									
									// Menu Item: Wishlist
//									if (auth.isAuthenticated) {
//										VStack(alignment: .leading, spacing: 15) {
//											NavigationLink(destination: ProductsWishlistView()) {
//												ProfileViewItem(text: Localizables.wishlist.text,
//															 icon: "heart.fill", iconIsSystemImage: true)
//											}
//
//											// Separator Line
//											ViewElements.verticalLineSeparator
//										}
//									}
									
									// Menu Item: Delete Account
									if (auth.isAuthenticated) {
										VStack(alignment: .leading, spacing: 15) {
											Button {
												onDeleteAccount()
											} label: {
												ProfileViewItem(text: Localizables.deleteAccount.text,
															 icon: "trash")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
									}
								}
								
								// MARK: - General
								VStack(alignment: .leading, spacing: 20) {
									Text(Localizables.general.text)
										.font(TextStyle.big.font)
										.foregroundColor(.textPrimary.opacity(0.6))
										.textBaseStyle()
									
									VStack(spacing: 20) {
										// Menu Item: Privacy Policy
										VStack(alignment: .leading, spacing: 15) {
											Button {
												showingPrivacyPolicy = true;
											} label: {
												ProfileViewItem(text: Localizables.privacyPolicy.text,
															 icon: "privacy-policy")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
										
										// Menu Item: Return Policy
										VStack(alignment: .leading, spacing: 15) {
											Button {
												showingReturnPolicy = true;
											} label: {
												ProfileViewItem(text: Localizables.returnPolicy.text,
															 icon: "return-policy")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
										
										// Menu Item: Contact Us
										VStack(alignment: .leading, spacing: 15) {
											Button {
												callHotline()
											} label: {
												ProfileViewItem(text: Localizables.contactUs.text,
															 icon: "contact-us")
											}
											
											// Separator Line
											ViewElements.verticalLineSeparator
										}
									}
								}
								
								Spacer()
								
								// Logout
								if (auth.isAuthenticated) {
									HStack {
										Spacer()
										
										Button {
											onLogout()
										} label: {
											HStack {
												Text(Localizables.logout.text)
												Image(systemName: "rectangle.portrait.and.arrow.right")
											}
											.foregroundColor(.tintPrimary)
											.textBaseStyle()
										}
									}
								}
							}
							.frame(width: geoGlobal.size.width * 0.8)
							.padding(.vertical, 40)
							
							// MARK: - Special Navigation
							// Notification View
							// SampleSimplification:: Views that were removed from the project were replaced with EmptyView
							NavigationLink("", destination: EmptyView(),
										   isActive: $showingNotificationItem)
						}
					}
				}
				
				if (presenter.isFetching || presenter.isSubmitting) {
					ProgressIndicator()
				}
			}

			// MARK: - NavBar
			.tintedNavBarStyle()
			.toolbar(content: {
				ToolbarItem(placement: .principal) {
					// Show title
					Text("")
						.tintedNavBarTitleStyle()
				}
			})
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.environment(\.rootPresentationMode, self.$showingLogin)
		.environment(\.rootPresentationMode, self.$showingRegister)

		// MARK: - Alerts
		.advancedAlert(alertManager: alertManager)
		
		// MARK: - Sheets
		.sheet(isPresented: $showingPrivacyPolicy) {
			// SampleSimplification:: 
//			WebBrowserView(urlPath: GlobalConstants.privacyPolicyLink, title: Localizables.privacyPolicy.text)
		}

		.sheet(isPresented: $showingReturnPolicy) {
			// SampleSimplification:: 
//			WebBrowserView(urlPath: GlobalConstants.returnPolicyLink, title: Localizables.returnPolicy.text)
		}

		// MARK: - Events
		.onChange(of: notificationViewHandler.didReceiveNewNotification, perform: { _ in
			if (notificationViewHandler.notificationItemType == .order) {
				// Make sure any sheets are dismissed
				showingStorePicker = false;
				showingPrivacyPolicy = false;
				showingReturnPolicy = false;
				
				// Show notification item
				showingNotificationItem = true;
			}
		})
		.onChange(of: presenter.triggeredAlert) { _ in
			onTriggerAlert()
		}
	}
	
	// MARK: - Events Handlers
	private func onLogout() {
		alertManager.showConfirm(title: Localizables.logoutConfirmTitle.text,
								 message: Localizables.logoutConfirmMessage.text) {
			
			presenter.logout {
				auth.logoutUser();
			}
		}
	}
	
	private func onDeleteAccount() {
		alertManager.showConfirm(title: Localizables.deleteAccountTitle.text,
								 message: Localizables.deleteAccountConfirm.text) {
			
			presenter.deleteUser {
				// Logout if deletion succeeds
				auth.logoutUser();
			}
		}
	}
	
	private func onTriggerAlert() {
		alertManager.showError(title: presenter.alertInfo.title,
							   message: presenter.alertInfo.message,
							   actionButtonText: presenter.alertInfo.actionButtonText,
							   handler: presenter.alertInfo.actionButtonHandler);
	}

	private func callHotline() {
		// Prepare for call
		guard let url = URL(string: "tel://\(presenter.hotLine)") else {
			alertManager.showInfo(title: Localizables.failTitle.text,
								  message: ErrorType.internalError.localizedMessage);
			return;
		}

		UIApplication.shared.open(url);
	}

}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
			.environmentObject(Auth())
    }
}
