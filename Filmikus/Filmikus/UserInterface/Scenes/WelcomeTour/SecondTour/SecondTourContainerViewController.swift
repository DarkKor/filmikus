//
//  SecondTourContainerViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 17.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class SecondTourContainerViewController: ViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(onBackButtonTap), for: .touchUpInside)
        if traitCollection.userInterfaceIdiom == .pad {
            btn.isHidden = true
        }
        return btn
    }()
    
    private lazy var nextButton = ColoredBorderButton(
        title: "Далее",
        color: UIColor.gradient(from: .appGLightBlue, to: .appBlue, direction: .vertical),
        borderColor: .appLightBlueBorder,
        target: self,
        action: #selector(onNextButtonTap)
    )
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .appTransparentLightPurple
        view.tintColor = UIColor.gradient(from: .appGLightBlue, to: .appBlue, direction: .vertical)
        return view
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Пропустить", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.alpha = 0.4
        btn.addTarget(self, action: #selector(onSkipButtonTap), for: .touchUpInside)
        if traitCollection.userInterfaceIdiom == .pad {
            btn.isHidden = true
        }
        return btn
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.gradient(from: .appGDark, to: .appGDarkViolet, direction: .vertical)
    
        view.addSubviews(
            backButton,
            logoImageView,
            nextButton,
            progressView,
            skipButton
        )
        
        let genreVC = SelectGenreViewController()
        addChildViewController(viewController: genreVC)
        
        genreVC.view.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(25)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.leading.equalTo(view.safeAreaLayoutGuide).inset(40)
            } else {
                $0.centerX.equalToSuperview()
            }
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(progressView.snp.top).offset(-60)
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.height.equalTo(60)
                $0.width.equalToSuperview().dividedBy(2)
            } else {
                $0.height.equalTo(50)
                $0.width.equalToSuperview().dividedBy(1.1)
            }
        }
        
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            } else {
                $0.bottom.equalTo(skipButton.snp.top).offset(-30)
            }
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func addChildViewController(viewController: ViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    
    @objc
    private func onBackButtonTap(sender: UIButton) {
        
    }
    
    @objc
    private func onNextButtonTap(sender: UIButton) {
        
    }
    
    @objc
    private func onSkipButtonTap(sender: UIButton) {
        
    }
}
