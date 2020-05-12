//
//  CategoryHeaderSectionView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 12.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class CategoryHeaderSectionView: ReusableTableHeaderFooterView {
	
	private lazy var buttonMore: UIButton = {
		let button = UIButton()
		button.setTitle("Еще", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemOrange
		button.addTarget(self, action: #selector(onButtonMoreTap), for: .touchUpInside)
	
		return button
	}()

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		
		contentView.backgroundColor = .black
		textLabel?.textColor = .white
		
		contentView.addSubview(buttonMore)
		
		buttonMore.snp.makeConstraints {
			$0.right.centerY.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc
	private func onButtonMoreTap(sender: UIButton) {
		print("More")
	}
	
}
