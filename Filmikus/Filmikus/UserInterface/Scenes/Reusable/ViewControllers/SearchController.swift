//
//  SearchController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 29.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
	
	var warningText: String? {
		get {
			warningLabel.text
		}
		set {
			warningLabel.text = newValue
		}
	}
	
	private lazy var warningLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.1
		label.font = .boldSystemFont(ofSize: 17)
		return label
	}()
	
	override init(searchResultsController: UIViewController?) {
		super.init(searchResultsController: searchResultsController)

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//definesPresentationContext = true
		//obscuresBackgroundDuringPresentation = false
		
		view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		view.addSubview(warningLabel)
		warningLabel.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		
		searchBar.barTintColor = .appDarkBlue
		searchBar.tintColor = .white
		//searchBar.searchTextField.backgroundColor = UIColor.appDarkBlue.withAlphaComponent(0.3)
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
	
}
