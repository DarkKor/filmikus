//
//  CategoriesViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate: class {
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectCategory category: Category)
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectMovie movie: MovieModel)
}

class CategoriesViewController: UIViewController {
	
	weak var delegate: CategoriesViewControllerDelegate?
	
	private var categories: [Category] = []
	private var categoriesOffsets: [Int: CGFloat] = [:]
	
	private lazy var headerView: CategoriesHeaderView = {
		let screenSize = UIScreen.main.bounds
		let view = CategoriesHeaderView()
		view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width / 2.1)
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.backgroundColor = .clear
		table.separatorStyle = .none
		table.sectionHeaderHeight = 44
		table.delegate = self
		table.dataSource = self
		table.rowHeight = 220
		table.tableHeaderView = headerView
		table.showsVerticalScrollIndicator = false
		table.register(cell: CategoryTableViewCell<MovieCollectionViewCell>.self)
		table.register(headerFooterView: CategoryHeaderSectionView.self)
		return table
	}()
	
	override func loadView() {
		view = tableView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	func update(sliders: [SliderModel]) {
		guard let slider = sliders.first else { return }
		headerView.fill(slider: slider)
	}
    
	func update(categories: [Category]) {
		self.categories = categories
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		categories.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CategoryTableViewCell<MovieCollectionViewCell> = tableView.dequeueCell(for: indexPath)
		cell.setDelegate(delegate: self, withTag: indexPath.section)
		cell.contentOffset = categoriesOffsets[indexPath.section] ?? 0
		return cell
	}
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header: CategoryHeaderSectionView = tableView.dequeueHeaderFooter()
		let category = categories[section]
		header.fill(title: category.title)
		header.onTap = {
			self.delegate?.categoriesViewController(self, didSelectCategory: category)
		}
		return header
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? CategoryTableViewCell<MovieCollectionViewCell> else { return }
		categoriesOffsets[indexPath.section] = cell.contentOffset
	}
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categories[collectionView.tag].movies.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: MovieCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(movie: categories[collectionView.tag].movies[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let movie = categories[collectionView.tag].movies[indexPath.item]
		delegate?.categoriesViewController(self, didSelectMovie: movie)
	}
}
