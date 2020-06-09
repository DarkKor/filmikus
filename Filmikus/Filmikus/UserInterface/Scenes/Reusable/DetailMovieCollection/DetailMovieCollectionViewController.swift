//
//  DetailMovieCollectionViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 08.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol DetailMovieCollectionViewControllerDelegate: class {
	func detailMovieCollectionViewController(_ viewController: DetailMovieCollectionViewController, didSelectVideo video: Video)
	func detailMovieCollectionViewControllerSelectSignIn(_ viewController: DetailMovieCollectionViewController)
	func detailMovieCollectionViewControllerSelectSignUp(_ viewController: DetailMovieCollectionViewController)
	func detailMovieCollectionViewControllerSelectShowFilm(_ viewController: DetailMovieCollectionViewController)
}

class DetailMovieCollectionViewController: UIViewController {
	
	weak var delegate: DetailMovieCollectionViewControllerDelegate?
	
	private var sections: [DetailMovieSection] = []
	
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
			DetailMovieRelatedHeaderSectionView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: DetailMovieRelatedHeaderSectionView.reuseId
		)
		collection.register(cell: DetailMovieInfoCollectionViewCell.self)
		collection.register(cell: DetailMovieVideoCollectionViewCell.self)
		collection.register(cell: VideoCollectionViewCell.self)
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
	
	func update(section: DetailMovieSection) {
		guard let sectionIndex = sections.firstIndex(where: { $0 == section }) else { return }
		sections[sectionIndex] = section
		collectionView.reloadData()
		collectionView.scrollToItem(at: IndexPath(item: 0, section: sectionIndex), at: .top, animated: true)
	}
	
	func update(sections: [DetailMovieSection]) {
		self.sections = sections
		collectionView.reloadData()
	}
}

// MARK: - UICollectionViewDataSource

extension DetailMovieCollectionViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		sections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch sections[section] {
		case .video:
			return 1
		case .info:
			return 1
		case .related(let model):
			return model.videos.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch sections[indexPath.section] {
		case .video:
			return UICollectionReusableView(frame: .zero)
		case .info:
			return UICollectionReusableView(frame: .zero)
		case .related(let model):
			let headerView = collectionView.dequeueReusableSupplementaryView(
				ofKind: UICollectionView.elementKindSectionHeader,
				withReuseIdentifier: DetailMovieRelatedHeaderSectionView.reuseId,
				for: indexPath
			) as! DetailMovieRelatedHeaderSectionView
			headerView.fill(title: model.title)
			return headerView
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch sections[indexPath.section] {
		case let .video(model):
			let cell: DetailMovieVideoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.delegate = self
			cell.fill(model: model)
			return cell
		case let .info(model):
			let cell: DetailMovieInfoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.delegate = self
			cell.fill(model: model)
			return cell
		case let .related(model):
			let cell: VideoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
			cell.fill(video: model.videos[indexPath.item])
			return cell
		}
	}
	
}

// MARK: - UICollectionViewDataSource

extension DetailMovieCollectionViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch sections[indexPath.section] {
		case let .video(model):
			break
		case let .info(model):
			break
		case let .related(model):
			let video = model.videos[indexPath.item]
			delegate?.detailMovieCollectionViewController(self, didSelectVideo: video)
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailMovieCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		switch sections[section] {
		case .video(_):
			return .zero
		case .info(_):
			return .zero
		case .related(_):
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
		case let .related(model):
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
		case .related:
			return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		}
	}
}

// MARK: - AuthRequiredViewDelegate

extension DetailMovieCollectionViewController: AuthRequiredViewDelegate {
	
	func authRequiredViewDidSelectSignIn(_ view: AuthRequiredView) {
		delegate?.detailMovieCollectionViewControllerSelectSignIn(self)
	}
	
	func authRequiredViewDidSelectSignUp(_ view: AuthRequiredView) {
		delegate?.detailMovieCollectionViewControllerSelectSignUp(self)
	}
}

// MARK: - DetailMovieInfoCollectionViewCellDelegate

extension DetailMovieCollectionViewController: DetailMovieInfoCollectionViewCellDelegate {
	
	func detailMovieInfoCollectionViewCellShowFilm(_ cell: DetailMovieInfoCollectionViewCell) {
		delegate?.detailMovieCollectionViewControllerSelectShowFilm(self)
	}
}

