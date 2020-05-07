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
		table.rowHeight = 100
		table.register(cell: CategoryTableViewCell.self)
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
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		categories[section].title
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CategoryTableViewCell = tableView.dequeue(for: indexPath)
		cell.fill(category: categories[indexPath.section])
		return cell
	}
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
	
}
