//
//  NotificationsViewHandler.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 30/07/2023.
//

import Foundation
import Combine

@MainActor
class NotificationViewHandler: ObservableObject, NotificationManagerDelegate {

	// MARK: - View Flags
	// Trigger view to react for a notification
	@Published var didReceiveNewNotification: Bool = false
	@Published var didFinishAppLaunch: Bool = false		// to be used if a notification was sent while the app not alive

	// Data of item to navigate to
	@Published var notificationItemType: NotificationItemType?
	@Published var notificationItemID: Int?
	@Published var data1: String?
	@Published var data2: String?

	private var cancellables = Set<AnyCancellable>()

	init() {
		$didFinishAppLaunch.sink { [weak self] value in
			guard let self = self else { return }
			if (value) {
				self.checkNotificationsAtLaunch();
			}
		}.store(in: &cancellables)
	}

	// MARK: - NotificationManagerViewReaction
	func didReceiveNotificationPayload(_ payload: [AnyHashable : Any]) async {
		guard let itemType = payload[NotificationPayloadKey.itemType.rawValue] as? String,
			  let itemID = Int(payload[NotificationPayloadKey.itemID.rawValue] as? String ?? "") else {
			return;
		}
		
		guard let itemTypeValue = NotificationItemType(rawValue: itemType) else {
			return;
		}
		
		// Imact view
		notificationItemType = itemTypeValue;
		notificationItemID = itemID;
		data1 = payload[NotificationPayloadKey.data1.rawValue] as? String;
		data2 = payload[NotificationPayloadKey.data2.rawValue] as? String;
		didReceiveNewNotification.toggle();
	}
	
	/// Check if there was a notification tapped before app launch
	func checkNotificationsAtLaunch() {
		// If `didOpenNewNotification` is true, this means that a notification was opened before app launch and there was no chance to handle it because all view change subscriptions were not present yet.
		if (didReceiveNewNotification) {
			// Re-fire notification handlers after app launch
			didReceiveNewNotification.toggle();
		}
	}
}

// MARK: - Enums
// [refactor]TODO: Tightly-coupled with backend service
enum NotificationPayloadKey: String {
	case itemType
	case itemID
	case data1
	case data2
}

enum NotificationItemType: String {
	case product = "1"
	case order = "2"
}
