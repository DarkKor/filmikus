//
//  ReuseWelcomeViewController.swift
//  Filmikus
//
//  Created by Alexey Guschin on 12.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

class ReuseWelcomeViewController: ViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        if traitCollection.userInterfaceIdiom == .pad {
            imageView.contentMode = .scaleAspectFit
        }
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
    
    private var contentImageViewLeadingTrailing: Constraint?
    
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
        view.backgroundColor = UIColor.gradient(from: .appGDark, to: .appGDarkViolet, direction: .vertical)
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
                $0.top.lessThanOrEqualTo(logoImageView).inset(50)
                $0.centerY.equalToSuperview().offset(-40)
                $0.centerX.equalToSuperview()
                contentImageViewLeadingTrailing =  $0.leading.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(20).constraint
                $0.bottom.lessThanOrEqualTo(lblContent).inset(20)
            } else {
                $0.edges.equalToSuperview()
            }
        }
        
        lblContent.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(104)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(44)
        }
        
        ipadOrientationCheck()
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func ipadOrientationCheck() {
        if traitCollection.userInterfaceIdiom == .pad {
            if UIDevice.current.orientation.isLandscape {
                contentImageViewLeadingTrailing?.deactivate()
            } else {
                contentImageViewLeadingTrailing?.activate()
            }
        }
    }
    
    @objc
    private func orientationDidChanged(sender: Notification) {
        ipadOrientationCheck()
    }
}

