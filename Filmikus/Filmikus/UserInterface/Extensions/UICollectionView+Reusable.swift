//
//  UICollectionView+Reusable.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol ReusableCollectionViewCellProtocol: NSObjectProtocol {
	static var reuseID: String { get }
}

extension ReusableCollectionViewCellProtocol {
	static var reuseID: String {
		return String(describing: Self.self)
	}
}

extension UICollectionView {
	func register(cell: ReusableCollectionViewCellProtocol.Type) {
		register(cell, forCellWithReuseIdentifier: cell.reuseID)
	}
	
	func dequeue<CellType: ReusableCollectionViewCellProtocol>(for indexPath: IndexPath) -> CellType {
		return dequeueReusableCell(withReuseIdentifier: CellType.reuseID, for: indexPath) as! CellType
	}
}

class ReusableCollectionViewCell: UICollectionViewCell, ReusableCollectionViewCellProtocol {}
