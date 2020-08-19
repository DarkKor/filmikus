//
//  WelcomeTourViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 06.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FirstTourViewControllerDelegate: class {
    func firstTourViewControllerDidClose(_ viewController: FirstTourViewController)
    func firstTourViewControllerWillShowContent(_ viewController: FirstTourViewController)
}

class FirstTourViewController: ViewController {
    
    weak var delegate: FirstTourViewControllerDelegate?
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .appBlue
        return pageControl
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Пропустить", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.alpha = 0.4
        btn.addTarget(self, action: #selector(onSkipButtonTap), for: .touchUpInside)
        return btn
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    override func loadView() {
        view = UIView()
        view.addSubviews(scrollView, pageControl, skipButton)
        scrollView.addSubview(contentView)
        let firstWelcomeVC = ReuseWelcomeViewController(imgContentName: "welcomeFirst", contentText: "Более чем 5000 фильмов и сериалов")
        let secondWelcomeVC = ReuseWelcomeViewController(imgContentName: "welcomeSecond", contentText: "Смотри онлайн на любом устройстве")
        let thirdWelcomeVC = ReuseWelcomeViewController(imgContentName: "welcomeThird", contentText: "Море развлекательного контента")
        let welcomePayVC = FirstTourPayViewController(state: .welcome)
        welcomePayVC.delegate = self
        addChildViewController(viewController: firstWelcomeVC)
        addChildViewController(viewController: secondWelcomeVC)
        addChildViewController(viewController: thirdWelcomeVC)
        addChildViewController(viewController: welcomePayVC)
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.centerX.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
        }
        
        firstWelcomeVC.view.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        
        secondWelcomeVC.view.snp.makeConstraints {
            $0.leading.equalTo(firstWelcomeVC.view.snp.trailing)
            $0.width.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        
        thirdWelcomeVC.view.snp.makeConstraints {
            $0.leading.equalTo(secondWelcomeVC.view.snp.trailing)
            $0.width.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        
        welcomePayVC.view.snp.makeConstraints {
            $0.leading.equalTo(thirdWelcomeVC.view.snp.trailing)
            $0.width.equalTo(view)
            $0.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addChildViewController(viewController: ViewController) {
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.scrollView.contentOffset.x = size.width * CGFloat(self.pageControl.currentPage)
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc
    private func onSkipButtonTap(sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(self.pageControl.numberOfPages - 1), y: 0), animated: false)
        pageControl.currentPage = children.count - 1
        pageControl.isHidden = true
        skipButton.isHidden = true
        scrollView.isScrollEnabled = false
    }
}

// MARK: - UIScrollViewDelegate

extension FirstTourViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(x/w)
        if currentPage == 3 {
            skipButton.isHidden = true
            if traitCollection.userInterfaceIdiom == .phone {
                scrollView.isScrollEnabled = false
                pageControl.isHidden = true
            }
        } else {
            if traitCollection.userInterfaceIdiom == .pad {
                skipButton.isHidden = false
            }
        }
        pageControl.currentPage = currentPage
    }
}

// MARK: - FirstWelcomeTourPayViewControllerDelegate

extension FirstTourViewController: FirstTourPayViewControllerDelegate {
    func firstTourPayViewControllerWillShowContent(_ viewController: FirstTourPayViewController) {
        delegate?.firstTourViewControllerWillShowContent(self)
    }
    
    func firstTourPayViewControllerDidClickSignIn(_ viewController: FirstTourPayViewController) {
        let signInVC = SignInViewController()
        signInVC.delegate = self
        present(signInVC, animated: true)
    }
    
    func firstTourPayViewControllerDidClose(_ viewController: FirstTourPayViewController) {
        delegate?.firstTourViewControllerDidClose(self)
    }
}

// MARK: - SignInViewControllerDelegate

extension FirstTourViewController: SignInViewControllerDelegate {
    func signInViewControllerDidSelectClose(_ viewController: SignInViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func signInViewController(_ viewController: SignInViewController, didSignInWithPaidStatus isPaid: Bool) {
        delegate?.firstTourViewControllerWillShowContent(self)
    }
}
