//
//  DetailFunShowCollectionViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol DetailFunShowCollectionViewControllerDelegate: class {
	func detailFunShowCollectionViewController(_ viewController: DetailFunShowCollectionViewController, didSelectVideo video: Video)
	func detailFunShowCollectionViewControllerSelectSignIn(_ viewController: DetailFunShowCollectionViewController)
	func detailFunShowCollectionViewControllerSelectSignUp(_ viewController: DetailFunShowCollectionViewController)
	func detailFunShowCollectionViewControllerSelectSubscribe(_ viewController: DetailFunShowCollectionViewController)
	func detailFunShowCollectionViewControllerSelectShowFilm(_ viewController: DetailFunShowCollectionViewController)
}

class DetailFunShowCollectionViewController: UIViewController {
	
	weak var delegate: DetailFunShowCollectionViewControllerDelegate?
	
	private(set) var sections: [DetailFunShowSection] = []
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = 6
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collection.delegate = self
		collection.dataSource = self
		collection.showsVerticalScrollIndicator = false
		collection.register(
			DetailFunShowMoreSectionView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: DetailFunShowMoreSectionView.reuseId
		)
		collection.register(cell: DetailFunShowInfoCollectionViewCell.self)
		collection.register(cell: DetailFunShowVideoCollectionViewCell.self)
		collection.register(cell: VideoCollectionViewCell.self)
		return collection
	}()
	
	override func loadView() {
		view = collectionView
		view.backgroundColor = .appLightGray
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
		
	func update(sections: [DetailFunShowSection]) {
		self.sections = sections
		collectionView.reloadData()
		collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
	}
}

// MARK: - UICollectionViewDataSource

extension DetailFunShowCollectionViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		sections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch sections[section] {
		case .video:
			return 1
		case .info:
			return 1
		case .more(let model):
			return model.videos.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch sections[indexPath.section] {
		case .video:
			return UICollectionReusableView(frame: .zero)
		case .info:
			return UICollectionReusableView(frame: .zero)
		case .more(let model):
			let headerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: DetailFunShowMoreSectionView.reuseId,
				for: indexPath
			) as! DetailFunShowMoreSectionView
			headerView.fill(title: model.title)
			return headerView
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch sections[indexPath.section] {
		case let .video(model):
			let cell: DetailFunShowVideoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.delegate = self
			cell.fill(model: model)
			return cell
		case let .info(model):
			let cell: DetailFunShowInfoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.delegate = self
			cell.fill(model: model)
			return cell
		case let .more(model):
			let cell: VideoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.fill(video: model.videos[indexPath.item])
			return cell
		}
	}
	
}

// MARK: - UICollectionViewDataSource

extension DetailFunShowCollectionViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch sections[indexPath.section] {
		case .video(_):
			break
		case .info(_):
			break
		case let .more(model):
			let video = model.videos[indexPath.item]
			delegate?.detailFunShowCollectionViewController(self, didSelectVideo: video)
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailFunShowCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		switch sections[section] {
		case .video(_):
			return .zero
		case .info(_):
			return .zero
		case .more(_):
			return CGSize(width: 0, height: 30)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
		let padding = insets.left + insets.right
		switch sections[indexPath.section] {
		case .video:
			return CGSize(width: collectionView.bounds.width - padding, height: 0)
		case .info:
			return CGSize(width: collectionView.bounds.width - padding, height: 0)
		case let .more(model):
			let itemsInRow: CGFloat = 2
			let spacing = collectionLayout.minimumInteritemSpacing * (itemsInRow - 1)
			let width = (collectionView.bounds.size.width - spacing - padding) / itemsInRow
			let height = width / 1.33
			let titleHeight = model.videos[indexPath.row].title.height(
				withConstrainedWidth: CGFloat.greatestFiniteMagnitude,
				font: .systemFont(ofSize: 17)
			)
			return CGSize(width: width.rounded(.down), height: height + titleHeight)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		switch sections[section] {
		case .video:
			return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
		case .info:
			return UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
		case .more:
			return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		}
	}
}

// MARK: - NeedSubscriptionViewDelegate

extension DetailFunShowCollectionViewController: NeedSubscriptionViewDelegate {
	
	func needSubscriptionViewDidSelectSubscribe(_ view: NeedSubscriptionView) {
		delegate?.detailFunShowCollectionViewControllerSelectSubscribe(self)
	}
}

// MARK: - DetailFunShowInfoCollectionViewCellDelegate

extension DetailFunShowCollectionViewController: DetailFunShowInfoCollectionViewCellDelegate {
	
	func detailFunShowInfoCollectionViewCellShowFilm(_ cell: DetailFunShowInfoCollectionViewCell) {
		delegate?.detailFunShowCollectionViewControllerSelectShowFilm(self)
	}
}
