//
//  FilmsFilterQualityCollectionViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 01.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FilmsFilterQualityCollectionViewCellDelegate: class {
	func filmsFilterQualityCollectionViewCell(_ cell: FilmsFilterQualityCollectionViewCell, didSelectQuality quality: VideoQuality)
	func filmsFilterQualityCollectionViewCell(_ cell: FilmsFilterQualityCollectionViewCell, didDeselectQuality quality: VideoQuality)
}

class FilmsFilterQualityCollectionViewCell: ReusableCollectionViewCell {
	
	weak var delegate: FilmsFilterQualityCollectionViewCellDelegate?
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 17)
		return label
	}()
	
	private lazy var qualitiesStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .trailing
		stackView.axis = .horizontal
		stackView.spacing = 5
		return stackView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .white
		contentView.addSubview(titleLabel)
		contentView.addSubview(qualitiesStackView)

		titleLabel.snp.makeConstraints {
			$0.leading.top.bottom.equalToSuperview().inset(12)
		}
		qualitiesStackView.snp.makeConstraints {
			$0.trailing.equalToSuperview().inset(12)
			$0.leading.equalTo(titleLabel.snp.trailing).offset(5)

			$0.centerY.equalToSuperview()
		}
		
		VideoQuality.allCases.forEach {
			let button = QualityButton(quality: $0, target: self, action: #selector(onButtonTap))
			qualitiesStackView.addArrangedSubview(button)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
		
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		let fittingSize = systemLayoutSizeFitting(layoutAttributes.size)
		layoutAttributes.size.height = fittingSize.height
		return layoutAttributes
	}
	
	func fill(content: FilterQualityContentItem) {
		titleLabel.text = content.title
	}
	
	@objc
	private func onButtonTap(sender: QualityButton) {
		sender.isSelected.toggle()
		if sender.isSelected {
			delegate?.filmsFilterQualityCollectionViewCell(self, didSelectQuality: sender.quality)
		} else {
			delegate?.filmsFilterQualityCollectionViewCell(self, didDeselectQuality: sender.quality)
		}
	}
}
