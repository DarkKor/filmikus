//
//  UIColor+Gradient.swift
//  Filmikus
//
//  Created by Андрей Козлов on 04.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum Direction {
        case horizontal
        case vertical
    }
    
    static func gradient(from startColor: UIColor, to endColor: UIColor, direction: Direction = .horizontal) -> UIColor {
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        }
        UIGraphicsBeginImageContext(gradient.frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: outputImage)
    }
}
