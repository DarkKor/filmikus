//
//  AppDelegate.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	private let receiptStatusUpdater = ReceiptStatusUpdater()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = TabBarController()
		window?.makeKeyAndVisible()
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		receiptStatusUpdater.updateReceipt()
	}
}

