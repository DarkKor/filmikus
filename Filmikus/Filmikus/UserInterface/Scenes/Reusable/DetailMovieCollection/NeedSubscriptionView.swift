//
//  NeedSubscriptionView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 23.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol NeedSubscriptionViewDelegate: class {
	func needSubscriptionViewDidSelectSubscribe(_ view: NeedSubscriptionView)
}

class NeedSubscriptionView: UIView {
	
	weak var delegate: NeedSubscriptionViewDelegate?
	
	private lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	private let eyeImageView = UIImageView(image: UIImage(named: "eye"))
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 12)
		label.text = "Для просмотра необходимо подписаться"
		return label
	}()
	
	private lazy var subscriptionButton = BlueButton(title: "ПОДПИСАТЬСЯ", target: self, action: #selector(onSubscriptionButtonTap))
	
	init() {
		super.init(frame: .zero)
		backgroundColor = .appDarkBlue
		
		addSubview(contentView)
		addSubview(eyeImageView)
		
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(subscriptionButton)
		
		contentView.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(40)
		}
		
		eyeImageView.snp.makeConstraints {
			$0.centerX.equalTo(contentView)
			$0.centerY.equalTo(contentView.snp.top)
			$0.width.height.equalTo(40)
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.leading.top.trailing.equalToSuperview().inset(20)
		}
		
		subscriptionButton.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
			$0.leading.bottom.trailing.equalToSuperview().inset(20)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		contentView.rounded(radius: contentView.frame.height / 16)
	}
	
	@objc
	private func onSubscriptionButtonTap(sender: UIButton) {
		delegate?.needSubscriptionViewDidSelectSubscribe(self)
	}
}
