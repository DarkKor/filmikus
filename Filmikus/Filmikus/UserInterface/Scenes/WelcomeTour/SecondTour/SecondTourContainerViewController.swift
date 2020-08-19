//
//  SecondTourContainerViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 17.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol SecondTourContainerViewControllerDelegate: class {
    func secondTourContainerViewControllerDidOpenPay(_ viewController: SecondTourContainerViewController)
}

class SecondTourContainerViewController: ViewController {
    
    weak var delegate: SecondTourContainerViewControllerDelegate?
    
    private var selectedView = 0
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
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
            logoImageView,
            nextButton,
            progressView,
            skipButton
        )
        
        let selectGenreVC = SelectGenreViewController()
        selectGenreVC.delegate = self
        let selectContryOfOriginVC = SelectCountryOfOriginViewController()
        selectContryOfOriginVC.delegate = self
        selectContryOfOriginVC.view.alpha = 0
        let loadContentsVC = LoadContentsViewController()
        loadContentsVC.delegate = self
        loadContentsVC.view.alpha = 0
        addChildViewController(viewController: selectGenreVC)
        addChildViewController(viewController: selectContryOfOriginVC)
        addChildViewController(viewController: loadContentsVC)
        
        selectGenreVC.view.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.bottom.equalTo(nextButton.snp.top).offset(-100)
            } else {
                $0.bottom.equalTo(nextButton.snp.top).offset(-30)
            }
        }
        
        selectContryOfOriginVC.view.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.bottom.equalTo(nextButton.snp.top).offset(-100)
            } else {
                $0.bottom.equalTo(nextButton.snp.top).offset(-30)
            }
        }
        
        loadContentsVC.view.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.bottom.equalTo(progressView.snp.top).offset(-100)
            } else {
                $0.bottom.equalTo(progressView.snp.top).offset(-30)
            }
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
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.height.equalTo(60)
                $0.width.equalToSuperview().dividedBy(2)
                $0.bottom.equalTo(progressView.snp.top).offset(-60)
            } else {
                $0.height.equalTo(50)
                $0.width.equalToSuperview().dividedBy(1.1)
                $0.bottom.equalTo(progressView.snp.top).offset(-30)
            }
        }
        
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            } else {
                $0.bottom.equalTo(skipButton.snp.top).offset(-30)
            }
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func addChildViewController(viewController: ViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func toggleNextButton(with selectedRowsCount: Int?) {
        guard let selectedRowCount = selectedRowsCount else {
            nextButton.enable = false
            return
        }
        nextButton.enable = selectedRowCount > 0 ? true : false
    }
    
    @objc
    private func onNextButtonTap(sender: UIButton) {
        guard (selectedView + 1) <= children.count - 1 else {
            return
        }
        if let loadContentsVC = self.children[self.selectedView + 1] as? LoadContentsViewController {
            loadContentsVC.loadFilms()
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 0
                self.skipButton.alpha = 0
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.children[self.selectedView].view.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.children[self.selectedView + 1].view.alpha = 1
                self.progressView.progress += 0.33
                self.nextButton.enable = false
            }, completion: { _ in
                self.selectedView += 1
            })
        })
    }
    
    @objc
    private func onSkipButtonTap(sender: UIButton) {
      delegate?.secondTourContainerViewControllerDidOpenPay(self)
    }
}

// MARK: - SelectGenreViewControllerDelegate

extension SecondTourContainerViewController: SelectGenreViewControllerDelegate {
    func selectGenreViewController(_ viewController: ViewController, selectedRowsCount: Int?) {
        toggleNextButton(with: selectedRowsCount)
    }
}

// MARK: - SelectCountryOfOriginViewControllerDelegate

extension SecondTourContainerViewController: SelectCountryOfOriginViewControllerDelegate {
    func selectCountryOfOriginViewController(_ viewController: ViewController, selectedRowsCount: Int?) {
        toggleNextButton(with: selectedRowsCount)
    }
}

// MARK: - LoadContentsViewControllerDelegate

extension SecondTourContainerViewController: LoadContentsViewControllerDelegate {
    func loadContentsViewControllerAnimationDidOpenPay(_ viewController: LoadContentsViewController) {
        delegate?.secondTourContainerViewControllerDidOpenPay(self)
    }
    
    func loadContentsViewControllerAnimationDidStop(_ viewController: LoadContentsViewController) {
        progressView.progress = 1
    }
}
