//
//  FirstWelcomeTourPayViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FirstWelcomeTourPayViewControllerDelegate: class {
    func firstWelcomeTourPayViewControllerDidClickSignIn(_ viewController: FirstWelcomeTourPayViewController)
    func firstWelcomeTourPayViewControllerDidClose(_ viewController: FirstWelcomeTourPayViewController)
    func firstWelcomeTourPayViewControllerWillShowContent(_ viewController: FirstWelcomeTourPayViewController)
}

class FirstWelcomeTourPayViewController: ViewController {
    
    weak var delegate: FirstWelcomeTourPayViewControllerDelegate?
    
    private let storeKitService: StoreKitServiceType = StoreKitService.shared
    private let userFacade: UserFacadeType = UserFacade()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sky")
        return imageView
    }()
    
    private lazy var vFirstWelcomeTourPay: FirstWelcomeTourPayView = {
        let view = FirstWelcomeTourPayView()
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appCosmosBlue
        if traitCollection.userInterfaceIdiom == .pad {
            view.addSubviews(backgroundImageView, vFirstWelcomeTourPay)
            backgroundImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            vFirstWelcomeTourPay.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            
            view.addSubviews(backgroundImageView, scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubviews(vFirstWelcomeTourPay)
            
            backgroundImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            scrollView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
            
            vFirstWelcomeTourPay.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: -

extension FirstWelcomeTourPayViewController: FirstWelcomeTourPayViewDelegate {
    func firstWelcomeTourPayViewDidClickSignIn(_ view: FirstWelcomeTourPayView) {
        delegate?.firstWelcomeTourPayViewControllerDidClickSignIn(self)
    }
    
    func firstWelcomeTourPayViewDidClickSubscribe(_ view: FirstWelcomeTourPayView) {
        showActivityIndicator()
        storeKitService.loadProducts { (result) in
            guard let products = try? result.get() else { return }
            guard let selectedProduct = products.first(where: {$0.subscriptionPeriod?.numberOfUnits == 1 && $0.subscriptionPeriod?.unit == .month }) else { return }
            self.storeKitService.purchase(product: selectedProduct) { [weak self] result in
                guard let self = self else { return }
                self.hideActivityIndicator()
                switch result {
                case .success:
                    self.userFacade.updateReceipt { (status) in
                        guard self.userFacade.isSubscribed else { return }
                        self.showAlert(
                            message: "Вы успешно подписались!",
                            completion: { self.delegate?.firstWelcomeTourPayViewControllerWillShowContent(self) }
                        )
                    }
                case .failure(let error):
                    self.showAlert(
                        message: "Ошибка: \(error.localizedDescription)",
                        completion: nil
                    )
                }
            }
        }
    }
    
    func firstWelcomeTourPayViewDidClickRestorePurchase(_ view: FirstWelcomeTourPayView) {
        showActivityIndicator()
        storeKitService.restorePurchases { [weak self] (result) in
            guard let self = self else { return }
            self.userFacade.updateReceipt { [weak self] (model) in
                guard let self = self else { return }
                self.hideActivityIndicator()
            }
        }
    }
    
    func firstWelcomeTourPayViewDidClickClose(_ view: FirstWelcomeTourPayView) {
        delegate?.firstWelcomeTourPayViewControllerDidClose(self)
    }
}
