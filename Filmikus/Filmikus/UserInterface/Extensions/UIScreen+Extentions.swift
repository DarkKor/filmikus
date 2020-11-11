//
//  UIScreen+Extentions.swift
//  Filmikus
//
//  Created by Алексей Гущин on 11.11.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

extension UIScreen {
    static var isSmallScreen: Bool {
        let smalliPhoneHeight: CGFloat = 568
        return main.bounds.height <= smalliPhoneHeight
    }
}


