//
//  AppDelegate.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import FirebaseCore
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	private var coordinator: AppCoordinator!
	
	private let userFacade: UserFacadeType = UserFacade()
	
	private let receiptStatusUpdater = ReceiptStatusUpdater()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
		
		window = UIWindow(frame: UIScreen.main.bounds)
		coordinator = AppCoordinator(window: window!)
		coordinator.start()
		
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		receiptStatusUpdater.updateReceipt()
	}
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }  
}

