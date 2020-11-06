//
//  FirstWelcomeTourPayViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import StoreKit

protocol FirstTourPayViewControllerDelegate: class {
    func firstTourPayViewControllerDidClickSignIn(_ viewController: FirstTourPayViewController)
    func firstTourPayViewControllerDidClose(_ viewController: FirstTourPayViewController)
    func firstTourPayViewControllerWillShowContent(_ viewController: FirstTourPayViewController)
}

class FirstTourPayViewController: ViewController {
    
    weak var delegate: FirstTourPayViewControllerDelegate?
    
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
    
    private lazy var vFirstWelcomeTourPay: FirstWelcomeTourPayView = {
        let view = FirstWelcomeTourPayView(state: state)
        view.delegate = self
        return view
    }()
    
    init(
        state: PayViewState,
        userFacade: UserFacadeType = UserFacade()
    ) {
        self.state = state
        self.userFacade = userFacade
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        showActivityIndicator()
        storeKitService.loadProducts{ [weak self] (result) in
            self?.hideActivityIndicator()
            guard let products = try? result.get() else { return }
            guard let selectedProduct = products.first else { return }
            self?.product = selectedProduct
            self?.vFirstWelcomeTourPay.setPriceText(price: selectedProduct.price)
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
            vFirstWelcomeTourPay.rotate(isLandscape: UIDevice.current.orientation.isLandscape)
        }
    }
}

// MARK: - FirstWelcomeTourPayViewDelegate

extension FirstTourPayViewController: FirstWelcomeTourPayViewDelegate {
    func firstWelcomeTourPayViewDidClickSignIn(_ view: FirstWelcomeTourPayView) {
        delegate?.firstTourPayViewControllerDidClickSignIn(self)
    }
    
    func firstWelcomeTourPayViewDidClickSubscribe(_ view: FirstWelcomeTourPayView) {
        guard let selectedProduct = product else { return }
        showActivityIndicator()
        self.storeKitService.purchase(product: selectedProduct) { [weak self] result in
            guard let self = self else { return }
            self.hideActivityIndicator()
            switch result {
            case .success:
                self.userFacade.updateReceipt { (status) in
                    guard self.userFacade.isSubscribed else { return }
                    self.showAlert(
                        message: "Вы успешно подписались!",
                        completion: {
                            switch self.state {
                            case .regular:
                                self.dismiss(animated: true)
                            case .welcome:
                                self.delegate?.firstTourPayViewControllerWillShowContent(self)
                            }
                        })
                }
            case .failure(let error):
                self.showAlert(
                    message: "Ошибка: \(error.localizedDescription)",
                    completion: {
                        switch self.state {
                        case .regular:
                            self.dismiss(animated: true)
                        default:
                            break
                        }
                    }
                )
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
        switch state {
        case .welcome:
           delegate?.firstTourPayViewControllerDidClose(self)
        case .regular:
            onClose?()
        }
    }
}
