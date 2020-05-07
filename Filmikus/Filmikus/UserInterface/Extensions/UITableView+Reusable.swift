//
//  UITableView+Reusable.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol ReusableTableViewCellProtocol: NSObjectProtocol {
	static var reuseID: String { get }
}

extension ReusableTableViewCellProtocol {
	static var reuseID: String {
		String(describing: Self.self)
	}
}

extension UITableView {
	
	func register(cell: ReusableTableViewCellProtocol.Type) {
		register(cell, forCellReuseIdentifier: cell.reuseID)
	}
	
	func dequeue<CellType: ReusableTableViewCellProtocol>(for indexPath: IndexPath) -> CellType {
		return dequeueReusableCell(withIdentifier: CellType.reuseID, for: indexPath) as! CellType
	}
	
}

class ReusableTableViewCell: UITableViewCell, ReusableTableViewCellProtocol {}
