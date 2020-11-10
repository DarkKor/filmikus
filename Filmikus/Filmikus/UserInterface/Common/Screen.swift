//
//  Screen.swift
//  Filmikus
//
//  Created by Alexey Guschin on 10.11.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

struct Screen {
    static let smalliPhoneHeight: CGFloat = 568
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidht = UIScreen.main.bounds.width
    
    static func isSmallScreen() -> Bool {
        return screenHeight <= smalliPhoneHeight ? true : false
    }
    
    static func isIphoneXorPluse() -> Bool {
        return screenHeight >= 736 ? true : false
    }
}
