//
//  NotificationManager.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/07/2023.
//

import Foundation
import Firebase
import FirebaseMessaging
import FirebaseAnalytics

protocol PNotificationManager: UNUserNotificationCenterDelegate {
	var delegate: NotificationManagerDelegate? { get set }
	func setup()
	func bufferNotificationPayload(_ payload: [AnyHashable : Any])
	func finishProcessingNotificationPayload()
	func registerDeviceToken() async
}

// [refactor]TODO: This class is tightly coupled with the business of this app and needs to be more generic, like having specific item types that are part of this app's business. This may also includes NotificationPayloadKey, NotificationPayloadItemType, NotificationManagerViewReaction. Refactor.
class NotificationManager: NSObject, PNotificationManager {
	
	// MARK: - Dependencies
	// SampleSimplification:: 
//	@Inject private var userProfileInteractor: PUserProfileBusiness
	@Inject private var logger: Logging
	
	// MARK: - Data
	var fcmToken: String?
	
	// MARK: -
	weak var delegate: NotificationManagerDelegate?
	
	private var tempPayload: [AnyHashable : Any]?		// to temporarily hold a notification payload
	
	// MARK: - Init
	override init() {
		super.init();
	}
	
	func setup() {
		// Config Firebase
		FirebaseApp.configure()
		FirebaseConfiguration.shared.setLoggerLevel(.min)
		
		// Registering for Notifications
		UNUserNotificationCenter.current().delegate = self
		
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
		
		// MessagingDelegate
		Messaging.messaging().delegate = self
	}
	
	// MARK: - Handle notifications
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([[.banner, .sound]])
	}
	
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		process(response.notification)
		completionHandler()
	}
	
	// MARK: - Process notification
	private func process(_ notification: UNNotification) {
		//textLogger.log("Started processing notification content.\n")
		let userInfo = notification.request.content.userInfo
		UIApplication.shared.applicationIconBadgeNumber = 0;
		
		// Analytics
		Messaging.messaging().appDidReceiveMessage(userInfo);
		
		if (delegate == nil) {
			//textLogger.log("delegate not available, obviously app is still launching.\n")
			bufferNotificationPayload(userInfo);
		}
		else {
			//textLogger.log("To handle payload data.")
			handle(payload: userInfo);
		}
	}
	
	func bufferNotificationPayload(_ payload: [AnyHashable : Any]) {
		// textLogger.log("Buffing payload to tempPayload\n")
		tempPayload = payload;
	}
	
	func finishProcessingNotificationPayload() {
		guard let tempPayload = tempPayload else { return }
		//textLogger.log("To handle payload data.")
		handle(payload: tempPayload);
		//textLogger.log("Clearing tempPayload\n")
		self.tempPayload = nil;
	}
	
	private func handle(payload: [AnyHashable : Any]) {
		Task {
			//textLogger.log("Calling delegate:: \(delegate)\n")
			await delegate?.didReceiveNotificationPayload(payload);
		}
	}
}

// MARK: - MessagingDelegate
extension NotificationManager: MessagingDelegate {
	// Keep the app in sync of the device's token
	func messaging(
		_ messaging: Messaging,
		didReceiveRegistrationToken fcmToken: String?
	) {
		print("FCM Token:: \(fcmToken ?? "none")")
		//textLogger.log("FCM Token::\n\(fcmToken ?? "none")")
		
		self.fcmToken = fcmToken;
		
		let tokenDict = ["token": fcmToken ?? ""]
		NotificationCenter.default.post(
			name: Notification.Name("FCMToken"),
			object: nil,
			userInfo: tokenDict)
		
		Task(priority: .utility) {
			await registerDeviceToken();
		}
	}
	
	// Register user FCM token to backend
	func registerDeviceToken() async {
		guard let fcmToken = self.fcmToken else { return }
		
		let logTitle = "FCM Token";
		let logMessage = "Registering device FCM token to backend";
		
		// SampleSimplification:: 
//		do {
//			let result = try await userProfileInteractor.registerUserDevice(deviceToken: fcmToken);
//			
//			guard result else {
//				logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "Failed \(logTitle)", "\(logMessage) failed.");
//				return;
//			}
//			
//			logger.log(ofType: .info, file: #file, function: #function, line: "\(#line)", title: "Successful \(logTitle)", "\(logMessage) succeeded.");
//		}
//		catch {
//			logger.log(ofType: .error, file: #file, function: #function, line: "\(#line)", title: "Failed \(logTitle)", "\(logMessage) failed.");
//		}
	}
}

// MARK: - AppDelegate
extension AppDelegate {
	// Catch device token
	func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
	}

	// Device token error
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Notification Error: \(error.localizedDescription)")
	}
}

// MARK: - Delegates
protocol NotificationManagerDelegate: AnyObject {
	func didReceiveNotificationPayload(_ payload: [AnyHashable : Any]) async
}
