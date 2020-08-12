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

class WelcomeTourViewController: UIPageViewController {
    
    weak var welcomeTourDelegate: WelcomeTourViewControllerDelegate?
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Пропустить", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.alpha = 0.4
        btn.addTarget(self, action: #selector(onSkipButtonTap), for: .touchUpInside)
        return btn
    }()
    
    private var controllers = [ViewController]()
    
    init(welcomeType: WelcomeTypeModel) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        switch welcomeType {
        case .firstWelcomeType:
            let firstWelcomeVC = ReuseWelcomeViewController(imgContentName: "welcomeFirst", contentText: "Более чем 5000 фильмов и сериалов")
            let secondWelcomeVC = ReuseWelcomeViewController(imgContentName: "welcomeSecond", contentText: "Смотри онлайн на любом устройстве")
            let thirdWelcomeVC = ReuseWelcomeViewController(imgContentName: "welcomeThird", contentText: "Море развлекательного контента")
            controllers = [firstWelcomeVC, secondWelcomeVC, thirdWelcomeVC]
            setViewControllers([controllers[0]], direction: .forward, animated: true)
        case .secondWelcomeType:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in view.subviews{
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl {
                view.frame.origin.y = self.view.frame.size.height - 80
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = .appBlue
        pageControl.backgroundColor = .clear
        
        view.addSubview(skipButton)
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    private func onSkipButtonTap(sender: UIButton) {
        welcomeTourDelegate?.welcomeTourViewControllerDidClose(self)
    }
}

// MARK: - UIPageViewControllerDataSource

extension WelcomeTourViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? ViewController else {
            return nil
        }
        if let index = controllers.firstIndex(of: controller) {
            if index > 0 {
                return controllers[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? ViewController else {
                  return nil
              }
              if let index = controllers.firstIndex(of: controller) {
                if index < controllers.count - 1 {
                      return controllers[index + 1]
                  }
              }
              return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
