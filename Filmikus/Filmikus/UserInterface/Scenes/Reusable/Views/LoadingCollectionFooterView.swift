//
//  LoadingCollectionFooterView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class LoadingCollectionFooterView: UICollectionReusableView {
	
	static var reuseID: String {
		return "\(Self.self)"
	}
	
	private lazy var viewActivity = UIActivityIndicatorView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(viewActivity)
		viewActivity.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func startAnimating() {
		viewActivity.startAnimating()
	}
	
	func stopAnimating() {
		viewActivity.stopAnimating()
	}
	
}
