//
//  VideosViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {

	private lazy var categoriesViewController: CategoriesViewController = {
		let viewController = CategoriesViewController()
		viewController.delegate = self
		return viewController
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appDarkBlue
		addChild(categoriesViewController)
		view.addSubview(categoriesViewController.view)
		categoriesViewController.didMove(toParent: self)
		
		categoriesViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Видео"
    }
    
}


// MARK: - CategoriesViewControllerDelegate

extension VideosViewController: CategoriesViewControllerDelegate {
	
	func categoriesViewController(_ viewController: CategoriesViewController, didSelectFilm film: Film) {
		let detailFilmVC = DetailFilmViewController(film: film)
		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
