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
		UIGraphicsBeginImageContext(gradient.frame.size)
		gradient.render(in: UIGraphicsGetCurrentContext()!)
		let outputImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		let standardAppearance = UINavigationBarAppearance()
		standardAppearance.backgroundColor = .appDarkBlue
		standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		let compactAppearance = standardAppearance.copy()
		let scrollEdgeAppearance = standardAppearance.copy()
		compactAppearance.backgroundColor = UIColor(patternImage: outputImage!)
		scrollEdgeAppearance.backgroundColor = UIColor(patternImage: outputImage!)

		navigationBar.standardAppearance = standardAppearance
		navigationBar.compactAppearance = compactAppearance
		navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
		navigationBar.barStyle = .black
		navigationBar.prefersLargeTitles = true
		navigationBar.tintColor = .white
	}
    
}
