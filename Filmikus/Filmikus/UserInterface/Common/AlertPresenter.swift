//
//  AlertPresenter.swift
//  Filmikus
//
//  Created by Андрей Козлов on 11.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

/// Used for ViewControllers that need to present an alert.
protocol AlertPresenter {
	func showAlert(title: String, message: String, completion: (() -> Void)?)
}

extension AlertPresenter where Self: UIViewController {
	
	func showAlert(title: String = "Фильмикус", message: String, completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

		let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in completion?() }
		alertController.addAction(okAction)

		DispatchQueue.main.async {
			self.present(alertController, animated: true)
		}
	}

}
