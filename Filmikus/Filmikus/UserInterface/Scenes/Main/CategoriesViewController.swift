//
//  CategoriesViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
	
	private var items: [String] = []
	
	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.delegate = self
		table.dataSource = self
		return table
	}()
	
	override func loadView() {
		view = tableView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		UITableViewCell()
	}
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
	
}
