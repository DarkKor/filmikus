//
//  CategoriesViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate: class {
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectFilm film: Film)
}

class CategoriesViewController: UIViewController {
	
	weak var delegate: CategoriesViewControllerDelegate?
	
	private var categories: [Category] = []
	private var categoriesOffsets: [Int: CGFloat] = [:]
	
	private lazy var headerView: CategoriesHeaderView = {
		let screenSize = UIScreen.main.bounds
		let view = CategoriesHeaderView()
		view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width / 1.49)
		view.clipsToBounds = true
		let url = URL(string: "https://photo.tvigle.ru/res/tvigle/slider/2019/09/03/6b5adfe1-c5db-4ac1-a3ed-c5db6d5fb10b.jpg")
		view.setImage(with: url)
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
		table.register(cell: CategoryTableViewCell<FilmCollectionViewCell>.self)
		table.register(headerFooterView: CategoryHeaderSectionView.self)
		return table
	}()
	
	override func loadView() {
		view = tableView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

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
		let cell: CategoryTableViewCell<FilmCollectionViewCell> = tableView.dequeueCell(for: indexPath)
		cell.setDelegate(delegate: self, withTag: indexPath.section)
		cell.contentOffset = categoriesOffsets[indexPath.section] ?? 0
		return cell
	}
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header: CategoryHeaderSectionView = tableView.dequeueHeaderFooter()
		header.fill(title: categories[section].title)
		return header
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let cell = cell as? CategoryTableViewCell<FilmCollectionViewCell> else { return }
		categoriesOffsets[indexPath.section] = cell.contentOffset
	}
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categories[collectionView.tag].films.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: FilmCollectionViewCell = collectionView.dequeueCell(for: indexPath)
		cell.fill(film: categories[collectionView.tag].films[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let film = categories[collectionView.tag].films[indexPath.item]
		delegate?.categoriesViewController(self, didSelectFilm: film)
	}
}
