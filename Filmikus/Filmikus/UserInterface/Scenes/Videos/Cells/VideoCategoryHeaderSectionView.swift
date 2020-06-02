//
//  VideoCategoryHeaderSectionView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 25.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

protocol VideoCategoryHeaderSectionViewDelegate: class {
	func videoCategoryHeaderSectionView(_ view: VideoCategoryHeaderSectionView, didSelectCategoryAt index:  Int)
}

class VideoCategoryHeaderSectionView: UICollectionReusableView {
	
	weak var delegate: VideoCategoryHeaderSectionViewDelegate?
	
	static let reuseId = String(describing: VideoCategoryHeaderSectionView.self)
	
	private var categories: [VideoCategory] = []
	
	private let segmentControl: UnderlinedSegmentControl = {
		let segment = UnderlinedSegmentControl()
		segment.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
		return segment
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(segmentControl)
		
		segmentControl.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		categories.removeAll()
		segmentControl.removeAllSegments()
	}
	
	func fill(categories: [VideoCategory]) {
		self.categories = categories
		categories.forEach {
			self.segmentControl.insert(segment: $0.title)
		}
	}
	
	@objc
	private func segmentControlChanged(sender: UnderlinedSegmentControl) {
		let index = sender.selectedIndex
		delegate?.videoCategoryHeaderSectionView(self, didSelectCategoryAt: index)
	}
}
