//
//  MovieDetailInfoView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 05.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class MovieDetailInfoView: UIView {
	private lazy var stackView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			directorsLabel, actorsLabel, descriptionLabel
		])
		stack.axis = .vertical
		stack.spacing = 16
		return stack
	}()
	private let directorsLabel = UILabel()
	private let actorsLabel = UILabel()
	private let descriptionLabel = UILabel()
	
	init() {
		super.init(frame: .zero)
		directorsLabel.numberOfLines = 0
		actorsLabel.numberOfLines = 0
		descriptionLabel.numberOfLines = 0
		
		addSubview(stackView)
		
		stackView.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(16)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fill(detailModel: DetailMovieInfoSection) {
		self.directorsLabel.attributedText = self.formattedString(
			grayPart: "Режисеры: ",
			blackPart: detailModel.directors.map{ $0.name }.joined(separator: ", ")
		)
		self.actorsLabel.attributedText = self.formattedString(
			grayPart: "Актеры: ",
			blackPart: detailModel.actors.map{ $0.name }.joined(separator: ", ")
		)
		self.descriptionLabel.attributedText = self.formattedString(
			grayPart: "Описание: ",
			blackPart: detailModel.descr
		)
	}
	
	private func formattedString(grayPart: String, blackPart: String) -> NSAttributedString {
		let grayAttributed = NSAttributedString(
			string: grayPart,
			attributes: [
				.foregroundColor: UIColor.appGrayText,
				.font: UIFont.boldSystemFont(ofSize: 12)
			]
		)
		let blackAttributed = NSAttributedString(
			string: blackPart,
			attributes: [
				.foregroundColor: UIColor.black,
				.font: UIFont.systemFont(ofSize: 14)
			]
		)
		let result = NSMutableAttributedString(attributedString: grayAttributed)
		result.append(blackAttributed)
		return result
	}
}
