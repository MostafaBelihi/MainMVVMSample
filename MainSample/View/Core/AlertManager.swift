//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2023 Mostafa AlBelliehy. All rights reserved.
//

import SwiftUI

// MARK: - Alert Manager
/// Manages how to show and hide alerts, via a `SwiftUI` view.
/// Add `advancedAlert()` as a modieifer in your view and pass an instance of this class.
/// Use methods of this class to show suitable alerts.
class AlertManager: ObservableObject {
	// AlertType controls which buttons to show
	fileprivate var alertType: AlterType = .info
	typealias AlertHandlerClosure = (() -> Void)
	
	// Alert parameters
	fileprivate var title: String!
	fileprivate var message: String?
	
	fileprivate var isDestructive = false
	fileprivate var actionButtonText: String?
	fileprivate var handler: AlertHandlerClosure?

	// Show/hide flag
	@Published fileprivate var showingAlert: Bool = false
	
	// MARK: - Alert Methods
	func showInfo(title: String, message: String? = nil, actionButtonText: String? = nil, handler: AlertHandlerClosure? = nil) {
		alertType = .info;
		self.title = title;
		self.message = message;
		self.actionButtonText = actionButtonText;
		self.handler = handler;
		
		showingAlert = true;
	}
	
	func showConfirm(title: String, message: String, isDestructive: Bool = false, handler: @escaping AlertHandlerClosure) {
		alertType = .confirm;
		self.title = title;
		self.message = message;
		self.isDestructive = isDestructive;
		self.handler = handler;
		
		showingAlert = true;
	}
	
	func showError(title: String, message: String, actionButtonText: String? = nil, handler: AlertHandlerClosure? = nil) {
		alertType = .error;
		self.title = title;
		self.message = message;
		self.actionButtonText = actionButtonText;
		self.handler = handler;
		
		showingAlert = true;
	}
	
	enum AlterType {
		case info
		case confirm
		case error
	}
}

// MARK: - Alert Modifier
struct AdvancedAlertModifier: ViewModifier {
	@ObservedObject var alertManager: AlertManager
	
	func body(content: Content) -> some View {
		content
			.alert(alertManager.title ?? "", isPresented: $alertManager.showingAlert) {
				switch alertManager.alertType {
					case .info:
						if let actionButtonText = alertManager.actionButtonText {
							Button(actionButtonText, action: alertManager.handler ?? {})
						}
						else {
							Button(Localizables.ok.text, action: alertManager.handler ?? {})
						}
					
					case .confirm:
						Button(Localizables.yes.text, role: alertManager.isDestructive ? .destructive : .none, action: alertManager.handler ?? {})
						Button(Localizables.no.text, role: .cancel, action: {})
					
					case .error:
						if let actionButtonText = alertManager.actionButtonText, let handler = alertManager.handler {
							Button(actionButtonText, action: handler)
						}
						
						Button(alertManager.actionButtonText == nil ? Localizables.ok.text : Localizables.no.text, role: .cancel, action: {})
				}
			} message: {
				if let message = alertManager.message {
					Text(message)
				}
			}
	}
}

// MARK: - View Extension
extension View {
	/// Add `advancedAlert` to your view, pass an `AlertManager` instance to it, and user
	/// that instance to show your alerts.
	func advancedAlert(alertManager: AlertManager) -> some View {
		modifier(AdvancedAlertModifier(alertManager: alertManager))
	}
}
