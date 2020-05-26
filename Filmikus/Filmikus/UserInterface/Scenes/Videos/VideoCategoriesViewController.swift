//
//  VideoCategoriesViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol VideoCategoriesViewControllerDelegate: class {
	func videoCategoriesViewController(_ viewController: VideoCategoriesViewController, didSelectCategory category: VideoCategory)
}

class VideoCategoriesViewController: UIViewController {

	weak var delegate: VideoCategoriesViewControllerDelegate?
	
	private var categories: [VideoCategory] = []
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		layout.headerReferenceSize.height = 44
		return layout
	}()
	
	private(set) lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collection.delegate = self
		collection.dataSource = self
		collection.showsVerticalScrollIndicator = false
		collection.register(cell: VideoCategoryCollectionViewCell.self)
		collection.register(
			VideoCategoryHeaderSectionView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: VideoCategoryHeaderSectionView.reuseId
		)
		return collection
	}()
	
	override func loadView() {
		view = collectionView
		view.backgroundColor = .clear
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func update(categories: [VideoCategory]) {
		self.categories = categories
		collectionView.reloadData()
	}

}

// MARK: - UICollectionViewDataSource

extension VideoCategoriesViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: VideoCategoryCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(videoCategory: categories[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDataSource

extension VideoCategoriesViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: VideoCategoryHeaderSectionView.reuseId,
				for: indexPath
			)
			return headerView
		default:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let category = categories[indexPath.item]
		delegate?.videoCategoriesViewController(self, didSelectCategory: category)
	}
}

extension VideoCategoriesViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let padding = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right
		let width = (collectionView.bounds.size.width - padding)
		let height = width / 1.49
		return CGSize(width: width, height: height)
	}
}
