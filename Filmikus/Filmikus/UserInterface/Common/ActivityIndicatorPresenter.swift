//
//  ActivityIndicatorPresenter.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

/// Used for ViewControllers that need to present an activity indicator when loading data.
protocol ActivityIndicatorPresenter {

    /// The activity indicator
    var activityIndicator: UIActivityIndicatorView { get }

    /// Show the activity indicator in the view
    func showActivityIndicator()

    /// Hide the activity indicator in the view
    func hideActivityIndicator()
}

extension ActivityIndicatorPresenter where Self: UIViewController {

    func showActivityIndicator() {
        DispatchQueue.main.async {
			self.activityIndicator.style = .large
			self.activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.7)
			self.activityIndicator.color = .white
			self.activityIndicator.frame = CGRect(origin: .zero, size: self.view.bounds.size)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
