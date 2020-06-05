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
	func videoCategoriesViewController(_ viewController: VideoCategoriesViewController, didSelectSubcategory subcategory: VideoSubcategory)
}

class VideoCategoriesViewController: UIViewController {

	weak var delegate: VideoCategoriesViewControllerDelegate?
	
	private var categories: [VideoCategory] = []
	private var selectedCategoryIndex = 0
	
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
		collection.register(cell: VideoSubcategoryCollectionViewCell.self)
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
	
	func update(subcategories: [VideoSubcategory], by categoryId: Int) {
		guard let categoryIndex = categories.firstIndex(where: { $0.id == categoryId }) else { return }
		categories[categoryIndex].subcategories = subcategories
		collectionView.reloadData()
	}
}

// MARK: - UICollectionViewDataSource

extension VideoCategoriesViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard !categories.isEmpty else { return 0 }
		return categories[selectedCategoryIndex].subcategories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: VideoSubcategoryCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(videoSubategory: categories[selectedCategoryIndex].subcategories[indexPath.item])
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
			) as! VideoCategoryHeaderSectionView
			headerView.delegate = self
			headerView.fill(categories: categories)
			return headerView
		default:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let subcategory = categories[selectedCategoryIndex].subcategories[indexPath.item]
		delegate?.videoCategoriesViewController(self, didSelectSubcategory: subcategory)
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VideoCategoriesViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let elementsInRow: CGFloat
		switch traitCollection.userInterfaceIdiom {
		case .phone:
			elementsInRow = 1
		case .pad:
			elementsInRow = 2
		default:
			elementsInRow = 0
		}
		let spacing = collectionLayout.minimumInteritemSpacing * (elementsInRow - 1)
		let padding = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right
		let width = (collectionView.bounds.size.width - spacing - padding) / elementsInRow
		let height = width / 1.49
		return CGSize(width: width, height: height)
	}
}

// MARK: - VideoCategoryHeaderSectionViewDelegate

extension VideoCategoriesViewController: VideoCategoryHeaderSectionViewDelegate {
	
	func videoCategoryHeaderSectionView(_ view: VideoCategoryHeaderSectionView, didSelectCategoryAt index: Int) {
		selectedCategoryIndex = index
		delegate?.videoCategoriesViewController(self, didSelectCategory: categories[index])
	}
}
