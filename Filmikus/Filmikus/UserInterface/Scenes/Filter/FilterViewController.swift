//
//  FilterViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
	func filterViewController(_ viewController: FilterViewController, didSelectFilterItem item: FilterItem)
}

class FilterViewController: UIViewController {
	
	weak var delegate: FilterViewControllerDelegate?

	private var items: [FilterItem] = [
		.genre(FilterContentItem(title: "Жанр", detail: "Все")),
		.country(FilterContentItem(title: "Страна", detail: "Все")),
		.year(FilterContentItem(title: "Год", detail: "Все")),
		.quality(FilterContentItem(title: "Качество", detail: "Все")),
		.sort(FilterContentItem(title: "Сортировать", detail: "По популярности"))
	]
	
	private(set) lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .clear
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorInset = .zero
		tableView.register(cell: ReusableTableViewCell.self)
		return tableView
	}()
	
	override func loadView() {
		view = tableView
	}
	
	func updateFilter(item: FilterItem) {
		items = items.map { $0 == item ? item : $0 }
		tableView.reloadData()
	}

}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell: ReusableTableViewCell = tableView.dequeueCell(for: indexPath)
		let cell = ReusableTableViewCell(style: .value1, reuseIdentifier: ReusableTableViewCell.reuseID)
		cell.accessoryType = .disclosureIndicator
		let content = items[indexPath.row].content
		cell.textLabel?.text = content.title
		cell.textLabel?.font = .boldSystemFont(ofSize: 17)
		cell.detailTextLabel?.text = content.detail
		cell.selectionStyle = .none
		return cell
	}
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.filterViewController(self, didSelectFilterItem: items[indexPath.row])
	}
}
