//
//  NavigationController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let gradient = CAGradientLayer()
		gradient.frame = navigationBar.bounds
		gradient.colors = [UIColor(red: 238, green: 135, blue: 85).cgColor, UIColor(red: 103, green: 56, blue: 162).cgColor]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 0)
		//navigationBar.layer.addSublayer(gradient)
		UIGraphicsBeginImageContext(gradient.frame.size)
		gradient.render(in: UIGraphicsGetCurrentContext()!)
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		//navigationBar.setBackgroundImage(outputImage, for: .default)
		navigationBar.barStyle = .black
		navigationBar.barTintColor = UIColor(patternImage: outputImage!)
		navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
	}
    
}
