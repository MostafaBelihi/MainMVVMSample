//
//  AppDelegate.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 29/07/2023.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {

	@Inject var notificationManager: PNotificationManager
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		// Setup Notifications
		notificationManager.setup();
		application.registerForRemoteNotifications();

		return true;
	}
	
}
