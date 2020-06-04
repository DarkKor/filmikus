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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
		
		StoreKitService.shared.startWith(
			productIds: [
				"com.filmikustestsubscription.testapp",
				"com.filmikustestsubscription.year.testapp"
			],
			sharedSecret: "325bac5a10fd4dcd9274233dcf980c17"
		)

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = TabBarController()
		window?.makeKeyAndVisible()
		return true
	}


}

