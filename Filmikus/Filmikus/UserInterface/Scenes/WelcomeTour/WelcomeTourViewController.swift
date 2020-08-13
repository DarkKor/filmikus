//
//  WelcomeTourViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 06.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol WelcomeTourViewControllerDelegate: class {
    func welcomeTourViewControllerDidClose(_ viewController: WelcomeTourViewController)
}

class WelcomeTourViewController: ViewController {
    
    weak var delegate: WelcomeTourViewControllerDelegate?
    
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
        let welcomePayVC = FirstWelcomeTourPayViewController()
        addChildViewController(viewController: firstWelcomeVC)
        addChildViewController(viewController: secondWelcomeVC)
        addChildViewController(viewController: thirdWelcomeVC)
        addChildViewController(viewController: welcomePayVC)
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
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
    
    @objc
    private func onSkipButtonTap(sender: UIButton) {
        delegate?.welcomeTourViewControllerDidClose(self)
    }
}

extension WelcomeTourViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(x/w)
        if currentPage == 3 {
            scrollView.isScrollEnabled = false
            pageControl.isHidden = traitCollection.userInterfaceIdiom == .phone ? true : false
        }
        pageControl.currentPage = currentPage
    }
}
