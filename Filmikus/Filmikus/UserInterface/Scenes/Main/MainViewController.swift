//
//  MainViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 07.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
	
	private lazy var categoriesViewController = CategoriesViewController()
	
	override func loadView() {
		view = UIView()
		addChild(categoriesViewController)
		view.addSubview(categoriesViewController.view)
		categoriesViewController.didMove(toParent: self)
		
		categoriesViewController.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let categories = [
			Category(title: "Популярное", films: [Film()]),
			Category(title: "Рекомендуем", films: [Film()]),
			Category(title: "Фильмы", films: [Film()]),
			Category(title: "Сериалы", films: [Film()])

		]
		categoriesViewController.update(categories: categories)
    }

}
