//
//  VideoCategoryHeaderSectionView.swift
//  Filmikus
//
//  Created by Андрей Козлов on 25.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class VideoCategoryHeaderSectionView: UICollectionReusableView {
	
	static let reuseId = String(describing: VideoCategoryHeaderSectionView.self)
	
	private let segmentControl: UnderlinedSegmentControl = {
		let segment = UnderlinedSegmentControl(buttons: [
			"Все видео", "Авто-шоу", "Lifestyle", "Красота", "Мода"
		])
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
	
	@objc
	private func segmentControlChanged(sender: UnderlinedSegmentControl) {
		let index = sender.selectedIndex
		print(sender.buttons[index].title(for: .normal)!)
	}
}
