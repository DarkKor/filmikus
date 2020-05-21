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
			gradientColor = self.gradientColor(
				from: UIColor(red: 238, green: 135, blue: 85),
				to: UIColor(red: 103, green: 56, blue: 162)
			)
		case .bluePurple:
			gradientColor = self.gradientColor(
				from: UIColor(red: 81, green: 87, blue: 206),
				to: UIColor(red: 94, green: 53, blue: 165)
			)
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
    
	private func gradientColor(from startColor: UIColor, to endColor: UIColor) -> UIColor {
		let gradient = CAGradientLayer()
		gradient.frame = navigationBar.bounds
		gradient.colors = [startColor.cgColor, endColor.cgColor]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 0)
		UIGraphicsBeginImageContext(gradient.frame.size)
		gradient.render(in: UIGraphicsGetCurrentContext()!)
		let outputImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
		UIGraphicsEndImageContext()
		return UIColor(patternImage: outputImage)
	}
}
