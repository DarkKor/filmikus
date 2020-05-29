//
//  SearchController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
	
	override init(searchResultsController: UIViewController?) {
		super.init(searchResultsController: searchResultsController)
		
		searchBar.searchTextField.backgroundColor = UIColor.appDarkBlue.withAlphaComponent(0.3)
		searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
			string: "Поиск",
			attributes: [.foregroundColor : UIColor.white]
		)
		searchBar.searchTextField.textColor = .white
		
		if let leftView = searchBar.searchTextField.leftView as? UIImageView {
			leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
			leftView.tintColor = UIColor.white
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
}
