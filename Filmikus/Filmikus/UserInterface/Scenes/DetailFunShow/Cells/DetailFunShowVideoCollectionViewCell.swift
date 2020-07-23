//
//  DetailFunShowVideoCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import WebKit

typealias DetailFunShowVideoCollectionViewCellDelegate = AuthRequiredViewDelegate & NeedSubscriptionViewDelegate

class DetailFunShowVideoCollectionViewCell: ReusableCollectionViewCell {
	
	weak var delegate: DetailFunShowVideoCollectionViewCellDelegate? {
		didSet {
			authRequiredView.delegate = delegate
			needSubscriptionView.delegate = delegate
		}
	}
	
	private lazy var webView: WKWebView = {
		let webView = WKWebView()
		webView.scrollView.isScrollEnabled = false
		webView.backgroundColor = .black
		return webView
	}()

	private lazy var authRequiredView = AuthRequiredView()
	private lazy var needSubscriptionView = NeedSubscriptionView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(webView)
		contentView.addSubview(authRequiredView)
		contentView.addSubview(needSubscriptionView)

		webView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		authRequiredView.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
			$0.bottom.equalTo(webView)
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
		case .needAuthentication:
			authRequiredView.isHidden = false
			webView.isHidden = true
			needSubscriptionView.isHidden = true
		case .needSubscription:
			authRequiredView.isHidden = true
			webView.isHidden = true
			needSubscriptionView.isHidden = false
		case .watchMovie:
			authRequiredView.isHidden = true
			webView.isHidden = false
			needSubscriptionView.isHidden = true
		}
		guard let url = URL(string: model.videoUrl) else { return }
		webView.load(URLRequest(url: url))
	}
}

