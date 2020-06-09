//
//  DetailFunShowInfoCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol DetailFunShowInfoCollectionViewCellDelegate: class {
	func detailFunShowInfoCollectionViewCellShowFilm(_ cell: DetailFunShowInfoCollectionViewCell)
}

class DetailFunShowInfoCollectionViewCell: ReusableCollectionViewCell {
	
	weak var delegate: DetailFunShowInfoCollectionViewCellDelegate?
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .appDarkBlue
		label.font = .boldSystemFont(ofSize: 20)
		return label
	}()
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.textColor = .appDarkBlue
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = 0
		return label
	}()
	private lazy var showFilmButton = BlueBorderButton(title: "СМОТРЕТЬ ВИДЕО", target: self, action: #selector(onShowFilmButtonTap))

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.addSubview(titleLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(showFilmButton)

		titleLabel.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview().inset(16)
		}
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(16)
			$0.leading.trailing.equalToSuperview().inset(16)
		}
		showFilmButton.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
			$0.centerX.equalToSuperview()
			$0.width.equalToSuperview().dividedBy(2)
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
	
	func fill(model: DetailFunShowInfoSection) {
		titleLabel.text = model.title
		descriptionLabel.text = model.descr
	}
	
	@objc
	private func onShowFilmButtonTap(sender: UIButton) {
		delegate?.detailFunShowInfoCollectionViewCellShowFilm(self)
	}
}
