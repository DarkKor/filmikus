//
//  FirstWelcomeTourPayViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FirstWelcomeTourPayViewControllerDelegate: class {
    func firstWelcomeTourPayViewControllerWillAppear(_ viewController: FirstWelcomeTourPayViewController)
}

class FirstWelcomeTourPayViewController: ViewController {
    
    weak var delegate: FirstWelcomeTourPayViewControllerDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var vFirstWelcomeTourPay: FirstWelcomeTourPayView = {
        let view = FirstWelcomeTourPayView()
        return view
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appPurple
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(vFirstWelcomeTourPay)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        vFirstWelcomeTourPay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if traitCollection.userInterfaceIdiom == .phone {
            delegate?.firstWelcomeTourPayViewControllerWillAppear(self)
        }
    }
}
