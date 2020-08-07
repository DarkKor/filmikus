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
    
    private var controllers = [ViewController]()
    
    init(welcomeType: WelcomeTypeModel) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        switch welcomeType {
        case .firstWelcomeType:
            let subscribeVC = SubscriptionViewController()
            subscribeVC.onClose = {
                self.welcomeTourDelegate?.welcomeTourViewControllerDidClose(self)
            }
            controllers.append(subscribeVC)
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
                   view.backgroundColor = UIColor.clear
               }
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
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
