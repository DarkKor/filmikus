//
//  TranspatentBorderButton.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class ColoredBorderButton: UIButton {
    
    private let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    private let background: UIColor
    private let borderColor: UIColor
    
    var enable: Bool {
        get {
            isEnabled
        }
        set {
            isEnabled = newValue
            backgroundColor = newValue ? background : UIColor.gradient(from: .appGrayText, to: .appGDisableButton, direction: .vertical)
            layer.borderColor = newValue ? borderColor.cgColor : UIColor.appButtonGrayBorder.cgColor
            setTitleColor(newValue ? .white : UIColor.white.withAlphaComponent(0.5), for: .normal)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        let width = defaultSize.width + insets.left + insets.right
        let height = defaultSize.height + insets.top + insets.bottom
        return CGSize(width: width, height: height)
    }
    
    init(title: String = "", color: UIColor, borderColor: UIColor, target: Any?, action: Selector) {
        self.background = color
        self.borderColor = borderColor
        super.init(frame: .zero)
        addTarget(target, action: action, for: .touchUpInside)
        
        if traitCollection.userInterfaceIdiom == .pad {
            titleLabel?.font =  .systemFont(ofSize: 24, weight: .medium) 
        } else {
            titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        }
       
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .selected)
        
        backgroundColor = color
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1.0
    }
    
    init(title: NSAttributedString, color: UIColor, borderColor: UIColor, target: Any?, action: Selector) {
        self.background = color
        self.borderColor = borderColor
        super.init(frame: .zero)
        addTarget(target, action: action, for: .touchUpInside)
        
        if traitCollection.userInterfaceIdiom == .pad {
            titleLabel?.font =  .systemFont(ofSize: 24, weight: .medium)
        } else {
            titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        }
       
        setAttributedTitle(title, for: .normal)
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        
        backgroundColor = color
        layer.borderColor = borderColor.cgColor
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
