//
//  VideosCollectionViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 21.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol VideosCollectionViewControllerDelegate: class {
	func videoCollectionViewController(_ viewController: VideosCollectionViewController, didSelectVideo video: Video)
}

class VideosCollectionViewController: UIViewController {
	
	weak var delegate: VideosCollectionViewControllerDelegate?

	private var videos: [Video] = []
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		layout.minimumInteritemSpacing = 6
		return layout
	}()
	
	private(set) lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collection.delegate = self
		collection.dataSource = self
		collection.showsVerticalScrollIndicator = false
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
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		let width = (collectionView.bounds.size.width - 6 - 12 * 2) / 2
		let height = width / 1.49
		collectionLayout.itemSize = CGSize(width: width, height: height)
	}
	
	func update(videos: [Video]) {
		self.videos = videos
		collectionView.reloadData()
	}

}

// MARK: - UICollectionViewDataSource

extension VideosCollectionViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		videos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: VideoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(video: videos[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDataSource

extension VideosCollectionViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let video = videos[indexPath.item]
		delegate?.videoCollectionViewController(self, didSelectVideo: video)
	}
}
