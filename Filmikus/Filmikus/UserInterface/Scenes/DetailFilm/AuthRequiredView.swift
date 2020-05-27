//
//  AuthRequiredView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class AuthRequiredView: UIView {
	
	private let eyeImageView = UIImageView(image: UIImage(named: "eye"))
	private let textContainer = UIView()
	private let textLabel = UILabel()
	
	init() {
		super.init(frame: .zero)
		backgroundColor = .appDarkBlue
		textContainer.backgroundColor = .white
		textLabel.text = "Для просмотра видео войдите или зарегистрируйтесь"
		textLabel.textAlignment = .center
		textLabel.numberOfLines = 0
		
		addSubview(textContainer)
		addSubview(eyeImageView)
		textContainer.addSubview(textLabel)
		
		textContainer.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(40)
		}
		textLabel.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(20)
		}
		eyeImageView.snp.makeConstraints {
			$0.centerX.equalTo(textContainer)
			$0.centerY.equalTo(textContainer.snp.top)
			$0.width.height.equalTo(40)
		}

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		textContainer.rounded(radius: textContainer.frame.height / 16)
	}
}
