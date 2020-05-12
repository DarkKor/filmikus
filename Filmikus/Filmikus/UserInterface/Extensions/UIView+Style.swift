//
//  UIView+Style.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

extension UIView {
	func rounded(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
		var cornerMasks = CACornerMask()
		if corners.contains(.allCorners) {
			cornerMasks.insert(.layerMinXMinYCorner)
			cornerMasks.insert(.layerMaxXMinYCorner)
			cornerMasks.insert(.layerMinXMaxYCorner)
			cornerMasks.insert(.layerMaxXMaxYCorner)
		}
		if corners.contains(.topLeft) {
			cornerMasks.insert(.layerMinXMinYCorner)
		}
		if corners.contains(.topRight) {
			cornerMasks.insert(.layerMaxXMinYCorner)
		}
		if corners.contains(.bottomLeft) {
			cornerMasks.insert(.layerMinXMaxYCorner)
		}
		if corners.contains(.bottomRight) {
			cornerMasks.insert(.layerMaxXMaxYCorner)
		}

		layer.maskedCorners = cornerMasks
		layer.cornerRadius = radius
		clipsToBounds = true
	}
}
