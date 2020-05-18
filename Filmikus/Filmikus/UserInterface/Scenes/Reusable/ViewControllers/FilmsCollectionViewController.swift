//
//  FilmsCollectionViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FilmsCollectionViewControllerDelegate: class {
	func filmsCollectionViewController(_ viewController: FilmsCollectionViewController, didSelectFilm film: Film)
}

class FilmsCollectionViewController: UIViewController {
	
	weak var delegate: FilmsCollectionViewControllerDelegate?
	
	private var films: [Film] = []
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		return layout
	}()
	
	private(set) lazy var collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		collection.delegate = self
		collection.dataSource = self
		collection.showsVerticalScrollIndicator = false
		collection.register(cell: FilmCollectionViewCell.self)
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
		let width = (collectionView.bounds.size.width - 10 - 12 * 2) / 2
		let height = width * 1.49
		collectionLayout.itemSize = CGSize(width: width, height: height)
	}
	
	func update(films: [Film]) {
		self.films = films
		collectionView.reloadData()
	}

}

// MARK: - UICollectionViewDataSource

extension FilmsCollectionViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		films.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: FilmCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(film: films[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDataSource

extension FilmsCollectionViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let film = films[indexPath.item]
		delegate?.filmsCollectionViewController(self, didSelectFilm: film)
	}
}
