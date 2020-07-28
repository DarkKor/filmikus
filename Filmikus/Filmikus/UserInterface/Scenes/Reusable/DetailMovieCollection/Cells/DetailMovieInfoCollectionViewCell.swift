//
//  DetailMovieInfoCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol DetailMovieInfoCollectionViewCellDelegate: class {
	func detailMovieInfoCollectionViewCellShowFilm(_ cell: DetailMovieInfoCollectionViewCell)
}

class DetailMovieInfoCollectionViewCell: ReusableCollectionViewCell {
	
	weak var delegate: DetailMovieInfoCollectionViewCellDelegate?
	
	private lazy var mainInfoView = MovieMainInfoView()
	private lazy var separatorView = UIView()
	private lazy var detailInfoView = MovieDetailInfoView()
	private lazy var showFilmButton = BlueBorderButton(title: "СМОТРЕТЬ ФИЛЬМ", target: self, action: #selector(onShowFilmButtonTap))

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(mainInfoView)
		contentView.addSubview(separatorView)
		contentView.addSubview(detailInfoView)
		contentView.addSubview(showFilmButton)
		
		contentView.backgroundColor = .white
		separatorView.backgroundColor = .separator

		mainInfoView.snp.makeConstraints {
			$0.top.left.right.equalToSuperview()
		}
		separatorView.snp.makeConstraints {
			$0.top.equalTo(mainInfoView.snp.bottom)
			$0.left.right.equalToSuperview()
			$0.height.equalTo(1)
		}
		detailInfoView.snp.makeConstraints {
			$0.top.equalTo(separatorView.snp.bottom)
			$0.left.right.equalToSuperview()
		}
		showFilmButton.snp.makeConstraints {
			$0.top.equalTo(detailInfoView.snp.bottom).offset(10)
			$0.centerX.equalToSuperview()
			if traitCollection.userInterfaceIdiom == .pad {
				$0.width.equalToSuperview().dividedBy(2)
			} else {
				$0.width.equalToSuperview().inset(16)
			}
			$0.bottom.equalToSuperview().inset(16)
			$0.height.equalTo(44)
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
	
	func fill(model: DetailMovieInfoSection) {
		mainInfoView.fill(movie: model)
		detailInfoView.fill(detailModel: model)
		showFilmButton.setTitle(model.showButtonText, for: .normal)
	}
	
	@objc
	private func onShowFilmButtonTap(sender: UIButton) {
		delegate?.detailMovieInfoCollectionViewCellShowFilm(self)
	}
}
