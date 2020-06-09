//
//  DetailMovieRelatedHeaderSectionView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class DetailMovieRelatedHeaderSectionView: UICollectionReusableView {

	static let reuseId = String(describing: DetailMovieRelatedHeaderSectionView.self)
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 20)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(titleLabel)
		
		titleLabel.snp.makeConstraints {
			$0.top.bottom.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(12)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(title: String) {
		titleLabel.text = title
	}
}
