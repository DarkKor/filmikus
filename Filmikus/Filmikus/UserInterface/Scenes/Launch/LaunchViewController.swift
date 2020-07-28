//
//  LaunchViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 27.07.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

protocol LaunchViewControllerDelegate: class {
	func launchViewController(_ viewController: LaunchViewController, didReceiveAccess type: AccessTypeModel)
}

class LaunchViewController: UIViewController {
	
	weak var delegate: LaunchViewControllerDelegate?
	
	private let userFacade: UserFacadeType = UserFacade()

	private lazy var logoImageView = UIImageView(image: UIImage(named: "logo"))
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appDarkBlue
		view.addSubview(logoImageView)
		
		logoImageView.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard !userFacade.isSubscribed else {
			delegate?.launchViewController(self, didReceiveAccess: .allAppWithoutContent)
			return
		}
		userFacade.accessType { (result) in
			switch result {
			case .success(let accessType):
				self.delegate?.launchViewController(self, didReceiveAccess: accessType)
			case .failure(let error):
				print(error)
			}
		}
	}
}
