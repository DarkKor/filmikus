//
//  TranspatentBorderButton.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class TranspatentBorderButton: UIButton {
    
    private let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        let width = defaultSize.width + insets.left + insets.right
        let height = defaultSize.height + insets.top + insets.bottom
        return CGSize(width: width, height: height)
    }
    
    init(title: String = "", target: Any?, action: Selector) {
        super.init(frame: .zero)
        addTarget(target, action: action, for: .touchUpInside)
        
        titleLabel?.font = .boldSystemFont(ofSize: 12)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .selected)
        backgroundColor = .appTransparentLightPurple
        layer.borderColor = UIColor.appLightPurple.cgColor
        layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rounded(radius: bounds.height / 2)
    }
    

}
