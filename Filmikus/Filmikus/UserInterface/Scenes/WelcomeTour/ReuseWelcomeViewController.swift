//
//  ReuseWelcomeViewController.swift
//  Filmikus
//
//  Created by Alexey Guschin on 12.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class ReuseWelcomeViewController: ViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var lblContent: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 36, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        }
        return lbl
    }()
    
    init(imgContentName: String, contentText: String) {
        super.init(nibName: nil, bundle: nil)
        contentImageView.image = UIImage(named: imgContentName)
        lblContent.text = contentText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appDarkBlue
        view.addSubview(contentImageView)
        if traitCollection.userInterfaceIdiom == .pad {
            view.addSubview(logoImageView)
            view.addSubview(lblContent)
        } else {
            contentImageView.addSubview(logoImageView)
            contentImageView.addSubview(lblContent)
        }
       
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        contentImageView.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(logoImageView).inset(65)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(119)
                $0.width.equalTo(contentImageView)
            } else {
                $0.edges.equalToSuperview()
            }
        }
        
        lblContent.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(104)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
    }
}

