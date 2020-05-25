//
//  FilmsCollectionViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FilmsCollectionViewControllerDelegate: class {
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilter item: FilterItem)
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film)
	func filmsCollectionViewControllerShouldShowActivity(_ viewController: FilmsCollectionViewController) -> Bool
}

class FilmsCollectionViewController: UIViewController {
	
	weak var delegate: FilmsCollectionViewControllerDelegate?
	private var filterItems: [FilterItem] = []
	private var films: [Film] = []
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		layout.footerReferenceSize.height = 60
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collection.delegate = self
		collection.dataSource = self
		collection.showsVerticalScrollIndicator = false
		collection.register(cell: FilmCollectionViewCell.self)
		collection.register(cell: FilmsFilterCollectionViewCell.self)
		collection.register(
			LoadingCollectionFooterView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: LoadingCollectionFooterView.reuseID
		)
		return collection
	}()
	
	override func loadView() {
		view = collectionView
		view.backgroundColor = .clear
	}
	
	func update(films: [Film]) {
		self.films = films
		collectionView.reloadData()
	}
	
	func update(filterItems: [FilterItem]) {
		self.filterItems = filterItems
		collectionView.reloadData()
	}
	
	func update(filterItem: FilterItem) {
		filterItems = filterItems.map {
			if $0 == filterItem {
				return filterItem
			}
			return $0
		}
		collectionView.reloadData()
	}

}

// MARK: - UICollectionViewDataSource

extension FilmsCollectionViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0: return filterItems.count
		case 1: return films.count
		default: return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch indexPath.section {
		case 0:
			let cell: FilmsFilterCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.fill(content: filterItems[indexPath.item].content)
			return cell
		case 1:
			let cell: FilmCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.fill(film: films[indexPath.item])
			return cell
		default:
			return UICollectionViewCell()
		}
	}
}

// MARK: - UICollectionViewDataSource

extension FilmsCollectionViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			let filterItem = filterItems[indexPath.item]
			delegate?.filmsCollectionViewController(self, didSelectFilter: filterItem)
		case 1:
			let film = films[indexPath.item]
			delegate?.filmsCollectionViewController(self, didSelectFilm: film)
		default:
			break
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingCollectionFooterView.reuseID,
                for: indexPath
            )
            return footerView
        default:
            return UICollectionReusableView()
        }
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		guard indexPath.section == 1 else { return }
		guard let footerView = view as? LoadingCollectionFooterView else { return }
		let showActivity = delegate?.filmsCollectionViewControllerShouldShowActivity(self) ?? false
		showActivity ? footerView.startAnimating() : footerView.stopAnimating()
	}
	
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilmsCollectionViewController: UICollectionViewDelegateFlowLayout {
		
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch indexPath.section {
		case 0:
			return CGSize(width: collectionView.bounds.width, height: 0)
		case 1:
			let elementsInRow: CGFloat = 2
			let spacing = collectionLayout.minimumInteritemSpacing * (elementsInRow - 1)
			let padding = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right
			let width = (collectionView.bounds.size.width - spacing - padding) / elementsInRow
			let height = width * 1.49
			return CGSize(width: width, height: height)
		default:
			return .zero
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		switch section {
		case 0:
			return .zero
		case 1:
			return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		default:
			return .zero
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		switch section {
		case 0:
			return 1
		case 1:
			return 10
		default:
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		switch section {
		case 0:
			return .zero
		case 1:
			return CGSize(width: 60, height: 60)
		default:
			return .zero
		}
	}
}
