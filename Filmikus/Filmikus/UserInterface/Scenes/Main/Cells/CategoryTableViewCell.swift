//
//  CategoryTableViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class CategoryTableViewCell<Cell: ReusableCollectionViewCell>: ReusableTableViewCell {
	
	var contentOffset: CGFloat {
		get {
			return collectionView.contentOffset.x
		}
		set {
			collectionView.contentOffset.x = newValue
		}
	}
	
	typealias CategoryDelegate = UICollectionViewDelegate & UICollectionViewDataSource
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collection.showsHorizontalScrollIndicator = false
		collection.register(cell: Cell.self)
		return collection
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clear
		collectionView.backgroundColor = .clear
		contentView.addSubview(collectionView)
		collectionView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let height = bounds.size.height
		let coefficient: CGFloat = 0.67
		collectionLayout.itemSize = CGSize(width: height * coefficient, height: height)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		collectionView.delegate = nil
		collectionView.dataSource = nil
	}
	
	func setDelegate(delegate: CategoryDelegate, withTag tag: Int) {
		collectionView.delegate = delegate
		collectionView.dataSource = delegate
		collectionView.tag = tag
	}

}
