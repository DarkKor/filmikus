//
//  NavigationController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
	
	enum GradientStyle {
		case orangePurple
		case bluePurple
	}
	
	func apply(gradientStyle: GradientStyle) {
		let gradientColor: UIColor
		switch gradientStyle {
		case .orangePurple:
			gradientColor = UIColor.gradient(from: .appPeach, to: .appViolet)
		case .bluePurple:
			gradientColor = UIColor.gradient(from: .appGBlue, to: .appGViolet)
		}
		
		let standardAppearance = UINavigationBarAppearance()
		standardAppearance.backgroundColor = .appDarkBlue
		standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		let compactAppearance = standardAppearance.copy()
		let scrollEdgeAppearance = standardAppearance.copy()
		compactAppearance.backgroundColor = gradientColor
		scrollEdgeAppearance.backgroundColor = gradientColor

		navigationBar.standardAppearance = standardAppearance
		navigationBar.compactAppearance = compactAppearance
		navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
		navigationBar.barStyle = .black
		navigationBar.prefersLargeTitles = true
		navigationBar.tintColor = .white
	}
}
