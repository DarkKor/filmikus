//
//  DetailFilmViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 15.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class DetailFilmViewController: UIViewController {
	
	private let film: Film
	
	private lazy var mainInfoView = FilmMainInfoView()
	
	private lazy var directorsLabel = UILabel()
	private lazy var actorsLabel = UILabel()
	private lazy var descriptionLabel = UILabel()


	init(film: Film) {
		self.film = film
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		title = film.title
    }
    

}
