//
//  SecondTourPayViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 18.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

protocol SecondTourPayViewControllerDelegate: class {
    func secondTourPayViewControllerDidClickSignIn(_ viewController: SecondTourPayViewController)
    func secondTourPayViewControllerDidClose(_ viewController: SecondTourPayViewController)
    func secondTourPayViewControllerWillShowContent(_ viewController: SecondTourPayViewController)
}

class SecondTourPayViewController: ViewController {
    
    weak var delegate: SecondTourPayViewControllerDelegate?
    
    private let state: PayViewState
    private let userFacade: UserFacadeType
    private let storeKitService: StoreKitServiceType = StoreKitService.shared
    
    private var product: SKProduct?
    
    var onClose: (() -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sky")
        return imageView
    }()
    
    private lazy var vSecondTourPay: SecondTourPayView = {
        let view = SecondTourPayView(state: state)
        view.delegate = self
        return view
    }()
    
    init(
        state: PayViewState,
        userFasade: UserFacadeType = UserFacade()
    ) {
        self.state = state
        self.userFacade = userFasade
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.gradient(from: .appGDark, to: .appGDarkViolet, direction: .vertical)
        if traitCollection.userInterfaceIdiom == .pad {
            view.addSubviews(backgroundImageView, vSecondTourPay)
            backgroundImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            vSecondTourPay.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            view.addSubviews(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubviews(vSecondTourPay)
            
            scrollView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            contentView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
            
            vSecondTourPay.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        storeKitService.loadProducts{ [weak self] (result) in
            self?.hideActivityIndicator()
            guard let products = try? result.get() else { return }
            guard let selectedProduct = products.first else { return }
            self?.product = selectedProduct
            self?.vSecondTourPay.setPriceText(price: selectedProduct.localizedPrice)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc
    private func orientationDidChanged(sender: Notification) {
        ipadOrientationCheck()
    }
    
    private func ipadOrientationCheck() {
        if traitCollection.userInterfaceIdiom == .pad {
            vSecondTourPay.checkRotate()
        }
    }
}

// MARK: - SecondTourPayViewDelegate

extension SecondTourPayViewController: SecondTourPayViewDelegate {
    func secondTourPayViewDidClickSignIn(_ view: SecondTourPayView) {
        delegate?.secondTourPayViewControllerDidClickSignIn(self)
    }
    
    func secondTourPayViewDidClickSubscribe(_ view: SecondTourPayView) {
        guard let selectedProduct = product else { return }
        showActivityIndicator()
        
        AnalyticsService.shared.track(event: "Purchase", properties: ["screen" : "secondTour"])
        
        self.storeKitService.purchase(product: selectedProduct) { [weak self] result in
            guard let self = self else { return }
            self.hideActivityIndicator()
            switch result {
            case .success:
                self.userFacade.updateReceipt { (status) in
                    guard self.userFacade.isSubscribed else { return }
                    self.showAlert(
                        message: "Подписка успешно оформлена!",
                        completion: {
                            switch self.state {
                            case .regular:
                                self.dismiss(animated: true)
                            case .welcome:
                                self.delegate?.secondTourPayViewControllerWillShowContent(self)
                            }
                        })
                    AnalyticsService.shared.track(event: "PurchaseSuccess",
                                                  properties: ["screen" : "secondTour",
                                                               "value" : selectedProduct.price,
                                                               "currency" : selectedProduct.priceLocale.currencyCode ?? "RUB"])
                    AnalyticsService.shared.trackPurchase(selectedProduct)
                }
            case .failure(let error):
                if (error as? SKError)?.code != SKError.Code.paymentCancelled {
                    self.showAlert(
                        message: "Ошибка: \(error.localizedDescription)",
                        completion: {
                            switch self.state {
                            case .regular:
                                self.dismiss(animated: true)
                            default:
                                break
                            }
                        })
                }
            }
        }
    }
    
    func secondTourPayViewDidClickRestorePurchase(_ view: SecondTourPayView) {
        showActivityIndicator()
        
        AnalyticsService.shared.track(event: "Restore", properties: ["screen" : "secondTour"])
        
        storeKitService.restorePurchases { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.userFacade.updateReceipt { [weak self] (model) in
                    guard let self = self else { return }
                    switch model {
                    case .success:
                        guard self.userFacade.isSubscribed else {
                            self.showAlert(
                                message: "Ошибка: не удалось восстановить покупки")
                            self.hideActivityIndicator()
                            return
                        }
                        self.showAlert(
                            message: "Покупки успешно восстановлены!",
                            completion: {
                                self.hideActivityIndicator()
                                switch self.state {
                                case .regular:
                                    self.dismiss(animated: true)
                                case .welcome:
                                    self.delegate?.secondTourPayViewControllerWillShowContent(self)
                                }
                            })
                        AnalyticsService.shared.track(event: "RestoreSuccess", properties: ["screen" : "secondTour"])
                    case .failure(let error):
                        self.showAlert(message: "Ошибка: \(error.localizedDescription)", completion: {
                            self.hideActivityIndicator()
                        })
                    }
                }
            case .failure(let error):
                self.showAlert(message: "Ошибка: \(error.localizedDescription)", completion: {
                    self.hideActivityIndicator()
                })
            }
        }
    }
    
    func secondTourPayViewDidClickClose(_ view: SecondTourPayView) {
        switch state {
        case .welcome:
            delegate?.secondTourPayViewControllerDidClose(self)
        case .regular:
            onClose?()
        }
    }
    
    func secondTourPayViewDidClickTerms(_ view: SecondTourPayView) {
        let alert = UIAlertController(title: "",
                                      message: "Ознакомьтесь с документами",
                                      preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        alert.addAction(UIAlertAction(title: "Политика конфиденциальности", style: .default, handler: { _ in
            let controller = SFSafariViewController(url: URL(string: StoreKitService.shared.privacyPolicy)!)
            self.present(controller, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Пользовательское соглашение", style: .default, handler: { _ in
            let controller = SFSafariViewController(url: URL(string: StoreKitService.shared.termsOfUse)!)
            self.present(controller, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
