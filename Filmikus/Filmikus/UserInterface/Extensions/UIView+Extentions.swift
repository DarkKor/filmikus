//
//  UIView+Extentions.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ subViews: UIView...) {
        for subview in subViews {
            addSubview(subview)
        }
    }
}
