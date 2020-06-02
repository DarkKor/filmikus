//
//  SelectItemViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 18.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol SelectableItem {
	var text: String { get }
}

enum SelectedItem {
	case all
	case itemIndex(Int)
}

class SelectItemViewController<Item: SelectableItem>: UITableViewController {
	
	typealias SelectItemBlock = (SelectedItem) -> Void
	
	private var selectItemBlock: SelectItemBlock
	
	private var items: [Item]
	
	init(items: [Item], onSelectItem block: @escaping SelectItemBlock) {
		self.items = items
		self.selectItemBlock = block
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.backgroundColor = .appLightGray
		tableView.separatorInset = .zero
		tableView.tableFooterView = UIView()
		tableView.register(cell: ReusableTableViewCell.self)
		navigationItem.largeTitleDisplayMode = .never
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Сбросить",
			style: .done,
			target: self,
			action: #selector(onResetButtonTap)
		)
	}
	
	// MARK: - UITableViewDataSource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ReusableTableViewCell = tableView.dequeueCell(for: indexPath)
		cell.textLabel?.text = items[indexPath.row].text
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectItemBlock(.itemIndex(indexPath.row))
		navigationController?.popViewController(animated: true)
	}
    
	@objc
	private func onResetButtonTap(sender: UIBarButtonItem) {
		selectItemBlock(.all)
		navigationController?.popViewController(animated: true)
	}
}
