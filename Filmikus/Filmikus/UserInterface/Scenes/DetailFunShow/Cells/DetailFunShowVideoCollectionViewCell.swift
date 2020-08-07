//
//  DetailFunShowVideoCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

class DetailFunShowVideoCollectionViewCell: ReusableCollectionViewCell {
	
	weak var delegate: NeedSubscriptionViewDelegate? {
		didSet {
			needSubscriptionView.delegate = delegate
		}
	}
	
	private lazy var webView: WKWebView = {
		let webView = WKWebView()
		webView.scrollView.isScrollEnabled = false
		webView.backgroundColor = .black
		return webView
	}()

	private lazy var needSubscriptionView = NeedSubscriptionView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(webView)
		contentView.addSubview(needSubscriptionView)

		webView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		needSubscriptionView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
			$0.bottom.equalTo(webView)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		let fittingSize = systemLayoutSizeFitting(
			layoutAttributes.size,
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .defaultLow
		)
		layoutAttributes.size.height = fittingSize.height
		return layoutAttributes
	}
	
	func fill(model: DetailFunShowVideoSection) {
		switch model.state {
		case .needSubscription:
			webView.isHidden = true
			needSubscriptionView.isHidden = false
		case .watchMovie:
			webView.isHidden = false
			needSubscriptionView.isHidden = true
		}
		guard let url = URL(string: model.videoUrl) else { return }
		webView.load(URLRequest(url: url))
	}
}

