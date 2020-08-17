//
//  SecondTourReuseCollectionViewCell.swift
//  Filmikus
//
//  Created by Алесей Гущин on 17.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SecondTourReuseCollectionViewCell: ReusableCollectionViewCell {
    
      private lazy var contentLabel: UILabel = {
          let lbl = UILabel()
          lbl.textColor = .white
          lbl.numberOfLines = 0
          lbl.lineBreakMode = .byWordWrapping
          lbl.textAlignment = .center
          if traitCollection.userInterfaceIdiom == .pad {
              lbl.font = .systemFont(ofSize: 32, weight: .regular)
          } else {
              lbl.font = .systemFont(ofSize: 18, weight: .regular)
          }
          return lbl
      }()
    
    var text: String? = String() {
        didSet {
            contentLabel.text = text
        }
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .appCellSelectedPurple : .appTransparentLightPurple
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .appTransparentLightPurple
        contentView.rounded(radius: frame.size.height / 16)
        contentView.layer.borderColor = UIColor.appLightPurple.cgColor
        contentView.layer.borderWidth = 1.0
        
        contentView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
