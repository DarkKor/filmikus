//
//  String+NSRange.swift
//  Filmikus
//
//  Created by dmitriy korolchenko on 24.12.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import Foundation

// MARK: NSRange
extension String {
    func nsRange(of searchString: String) -> NSRange? {
        let range = (self as NSString).range(of: searchString)
        if range.location == NSNotFound {
            return nil
        }
        return range
    }
    
    func lengthAsRange() -> NSRange {
        return NSRange(location: 0, length: count)
    }
}
