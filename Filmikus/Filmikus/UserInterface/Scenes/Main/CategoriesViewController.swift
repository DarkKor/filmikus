//
//  CategoriesViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
	
	private var categories: [Category] = []
	
	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.delegate = self
		table.dataSource = self
		table.rowHeight = 220
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
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header: CategoryHeaderSectionView = tableView.dequeueHeaderFooter()
		header.textLabel?.text = categories[section].title
		return header
	}
	
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		categories[section].title
//	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CategoryTableViewCell<FilmCollectionViewCell> = tableView.dequeueCell(for: indexPath)
		cell.setDelegate(delegate: self, withTag: indexPath.section)
		return cell
	}
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categories[collectionView.tag].films.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: FilmCollectionViewCell = collectionView.dequeue(for: indexPath)
		cell.fill(film: categories[collectionView.tag].films[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDelegate {}
