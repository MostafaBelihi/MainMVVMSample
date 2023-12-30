//
//  MainSampleApp.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import SwiftUI

@main
struct MainSampleApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	init() {
		Bundle.set(language: .arabic)
	}

	var body: some Scene {
        WindowGroup {
			TabBarView()
        }
    }
	
}
