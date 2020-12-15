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
		label.textAlignment = .center
		return label
	}()
	
	private lazy var activityIndicatorView: UIActivityIndicatorView = {
		let activity = UIActivityIndicatorView(style: .whiteLarge)
		activity.color = .white
		return activity
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
		
		view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		view.addSubview(warningLabel)
		view.addSubview(activityIndicatorView)
		warningLabel.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(20)
		}
		activityIndicatorView.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
		searchBar.barTintColor = .appDarkBlue
		searchBar.tintColor = .white
		//searchBar.searchTextField.backgroundColor = UIColor.appDarkBlue.withAlphaComponent(0.3)
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Поиск (не менее 4 символов)",
                attributes: [.foregroundColor : UIColor.white]
            )
        } else {
            // Fallback on earlier versions
        }
		searchBar.searchTextField.textColor = .white
		
		if let leftView = searchBar.searchTextField.leftView as? UIImageView {
			leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
			leftView.tintColor = UIColor.white
		}
	}
	
	func showActivityIndicator() {
		activityIndicatorView.startAnimating()
		warningLabel.isHidden = true
	}
	
	func hideActivityIndicator() {
		activityIndicatorView.stopAnimating()
		warningLabel.isHidden = false
	}
}
