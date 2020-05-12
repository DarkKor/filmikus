//
//  CategoryTableViewCell.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class CategoryTableViewCell<Cell: ReusableCollectionViewCell>: ReusableTableViewCell {
	
	typealias CategoryDelegate = UICollectionViewDelegate & UICollectionViewDataSource
	
	private lazy var collectionLayout: UICollectionViewLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 100, height: 200)
		layout.scrollDirection = .horizontal
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		
		collection.showsHorizontalScrollIndicator = false
		collection.register(view: Cell.self)
		return collection
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		collectionView.backgroundColor = .black
		contentView.addSubview(collectionView)
		collectionView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
