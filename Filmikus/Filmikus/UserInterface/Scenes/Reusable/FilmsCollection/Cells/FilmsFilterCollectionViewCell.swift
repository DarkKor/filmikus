//
//  FilmsFilterCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 24.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FilmsFilterCollectionViewCell: ReusableCollectionViewCell {
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 17)
		return label
	}()
	
	private let detailLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.textColor = .secondaryLabel
		return label
	}()
	
	private let arrowImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.addSubview(titleLabel)
		contentView.addSubview(detailLabel)
		contentView.addSubview(arrowImageView)
		detailLabel.setContentHuggingPriority(.required, for: .horizontal)
		titleLabel.snp.makeConstraints {
			$0.leading.top.bottom.equalToSuperview().inset(12)
		}
		arrowImageView.snp.makeConstraints {
			$0.trailing.equalToSuperview().inset(12)
			$0.centerY.equalToSuperview()
		}
		detailLabel.snp.makeConstraints {
			$0.trailing.equalTo(arrowImageView.snp.leading).offset(-5)
			$0.leading.equalTo(titleLabel.snp.trailing).offset(5)
			$0.centerY.equalToSuperview()
		}
		let configuration = UIImage.SymbolConfiguration(font: detailLabel.font, scale: .small)
		arrowImageView.image = UIImage(systemName: "chevron.right")?.withConfiguration(configuration)
		arrowImageView.tintColor = .lightGray
		arrowImageView.setContentHuggingPriority(.required, for: .horizontal)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
		detailLabel.text = nil
		
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		let fittingSize = systemLayoutSizeFitting(layoutAttributes.size)
		layoutAttributes.size.height = fittingSize.height
		return layoutAttributes
	}
	
	func fill(content: FilterContentItem) {
		titleLabel.text = content.title
		detailLabel.text = content.detail
	}
}
