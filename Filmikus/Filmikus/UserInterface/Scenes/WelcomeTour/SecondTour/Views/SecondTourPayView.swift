//
//  SecondTourPayView.swift
//  Filmikus
//
//  Created by Алесей Гущин on 18.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

protocol SecondTourPayViewDelegate: class {
    func secondTourPayViewDidClickSignIn(_ view: SecondTourPayView)
    func secondTourPayViewDidClickSubscribe(_ view: SecondTourPayView)
    func secondTourPayViewDidClickRestorePurchase(_ view: SecondTourPayView)
    func secondTourPayViewDidClickClose(_ view: SecondTourPayView)
    func secondTourPayViewDidClickTerms(_ view: SecondTourPayView)
}

class SecondTourPayView: UIView {
    
    weak var delegate: SecondTourPayViewDelegate?
    
    private let state: PayViewState
    
    private var price: String = "299 ₽"
    
    private var titleLableTopLandscape: Constraint?
    private var titleLableTop: Constraint?
    private var popCornImageViewTopLandscape: Constraint?
    private var popCornImageViewTop: Constraint?
    private var mainStackViewTopLandscape: Constraint?
    private var mainStackViewTop: Constraint?
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.text = "Фильмы подобраны\nСмотри 7 дней бесплатно"
        lbl.textAlignment = .center
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 24, weight: .semibold)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        }
        return lbl
    }()
    
    private lazy var popCornImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "popcorn"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var firstStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            filmStripImageViewContainer,
            filmStripLabel
        ])
        stv.spacing = 20
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var secondStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            tiketImageViewContainer,
            tiketLabel
        ])
        stv.spacing = 20
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var thirdStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            okImageViewContainer,
            okLabel
        ])
        stv.spacing = 20
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            firstStackView,
            secondStackView,
            thirdStackView
        ])
        stv.spacing = 15
        stv.axis = .vertical
        return stv
    }()
    
    private lazy var buttonStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        if state == .welcome {
            arrangedSubviews = [signInButton, restorePurchaseButton]
        } else {
            arrangedSubviews = [restorePurchaseButton]
        }
        let stv = UIStackView(arrangedSubviews: arrangedSubviews)
        if traitCollection.userInterfaceIdiom == .pad {
            stv.spacing = 25
            stv.axis = .horizontal
            stv.distribution = .fillEqually
        } else {
            stv.spacing = 6
            stv.axis = .vertical
        }
        return stv
    }()
    
    private lazy var filmStripImageViewContainer = UIView()
    private lazy var tiketImageViewContainer = UIView()
    private lazy var okImageViewContainer = UIView()
    
    private lazy var filmStripImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "filmStripWhite")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private lazy var filmStripLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "Более 5000 фильмов, сериалов"
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            lbl.textAlignment = .center
            lbl.adjustsFontSizeToFitWidth = true
            lbl.minimumScaleFactor = 0.2
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return lbl
    }()
    
    private lazy var tiketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tiketWhite")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private lazy var tiketLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            lbl.adjustsFontSizeToFitWidth = true
            lbl.minimumScaleFactor = 0.2
            lbl.textAlignment = .center
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return lbl
    }()
    
    private lazy var okImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "okWhite")
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var okLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        lbl.text = "Без рекламы"
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            lbl.adjustsFontSizeToFitWidth = true
            lbl.minimumScaleFactor = 0.2
            lbl.textAlignment = .center
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return lbl
    }()
    
    private lazy var subscribeButton = ColoredBorderButton(
        title: StoreKitService.shared.callToAction(price: price),
        color: UIColor.gradient(from: .appGLightBlue, to: .appBlue, direction: .vertical),
        borderColor: .appLightBlueBorder,
        target: self,
        action: #selector(onSubscribeButtonTap)
    )
    
    private lazy var cancelSubscribeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 14, weight: .bold)
        }
        lbl.text = StoreKitService.shared.subtitle
        return lbl
    }()
    
    private lazy var signInButton = ColoredBorderButton(
        title: "Есть аккаунт? Войти",
        color: .appTransparentLightPurple,
        borderColor: .appLightPurple,
        target: self,
        action: #selector(onSignInButtonTap)
    )
    
    private lazy var restorePurchaseButton = ColoredBorderButton(
        title: "Восстановить покупки",
        color: .appTransparentLightPurple,
        borderColor: .appLightPurple,
        target: self,
        action: #selector(onRestorePurchaseButtonTap)
    )
    
    private lazy var termsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.font = .systemFont(ofSize: 9, weight: .regular)
        lbl.attributedText = StoreKitService.shared.attributedTerms(price: "299 ₽")
        lbl.isUserInteractionEnabled = true
        lbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTermsLinkTap(sender:))))
        return lbl
    }()
    
    init(state: PayViewState) {
        self.state = state
        super.init(frame: .zero)
        configureView(device: traitCollection.userInterfaceIdiom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureView(device: UIUserInterfaceIdiom) {
        if device == .pad {
            addSubviews(
                logoImageView,
                closeButton,
                titleLabel,
                popCornImageView,
                mainStackView,
                subscribeButton,
                cancelSubscribeLabel,
                buttonStackView,
                termsLabel
            )
            filmStripImageViewContainer.addSubview(filmStripImageView)
            tiketImageViewContainer.addSubview(tiketImageView)
            okImageViewContainer.addSubview(okImageView)
            
            filmStripImageViewContainer.snp.makeConstraints {
                $0.width.equalTo(42)
                $0.height.equalTo(33)
            }
            
            filmStripImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            tiketImageViewContainer.snp.makeConstraints {
                $0.width.equalTo(42)
                $0.height.equalTo(33)
            }
            
            tiketImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            okImageViewContainer.snp.makeConstraints {
                $0.width.equalTo(42)
                $0.height.equalTo(33)
            }
            
            okImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            logoImageView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide).inset(25)
                $0.leading.equalTo(safeAreaLayoutGuide).inset(40)
            }
            
            closeButton.snp.makeConstraints {
                $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(25)
            }
            
            titleLabel.snp.makeConstraints {
                titleLableTop = $0.top.equalTo(logoImageView.snp.bottom).offset(25).constraint
                titleLableTopLandscape = $0.top.equalTo(popCornImageView.snp.bottom).offset(25).constraint
                $0.centerX.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(10)
            }
            
            popCornImageView.snp.makeConstraints {
                popCornImageViewTop = $0.top.equalTo(titleLabel.snp.bottom).offset(40).constraint
                popCornImageViewTopLandscape = $0.top.equalTo(logoImageView.snp.bottom).offset(40).constraint
                $0.centerX.equalToSuperview()
            }
            
            mainStackView.snp.makeConstraints {
                mainStackViewTop = $0.top.equalTo(popCornImageView.snp.bottom).offset(50).constraint
                mainStackViewTopLandscape = $0.top.equalTo(titleLabel.snp.bottom).offset(50).constraint
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.7)
            }
            
            subscribeButton.snp.makeConstraints {
                $0.height.equalTo(60)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.8)
                $0.top.equalTo(mainStackView.snp.bottom).offset(40)
            }
            
            cancelSubscribeLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(subscribeButton.snp.bottom).offset(20)
            }
            
            if state == .welcome {
                signInButton.snp.makeConstraints {
                    $0.height.equalTo(subscribeButton.snp.height)
                }
            }
            
            restorePurchaseButton.snp.makeConstraints {
                $0.height.equalTo(subscribeButton.snp.height)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(cancelSubscribeLabel.snp.bottom).offset(50)
                $0.centerX.equalToSuperview()
                if state == .welcome {
                    $0.leading.trailing.equalToSuperview().inset(50)
                } else {
                    $0.width.equalToSuperview().dividedBy(2)
                }
            }
            
            termsLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.top.greaterThanOrEqualTo(buttonStackView.snp.bottom).offset(10)
                $0.bottom.equalToSuperview().inset(20)
            }
            
            checkRotate()
            
        } else {
            addSubviews(
                logoImageView,
                closeButton,
                titleLabel,
                popCornImageView,
                filmStripLabel,
                tiketLabel,
                okLabel,
                subscribeButton,
                cancelSubscribeLabel,
                buttonStackView,
                termsLabel
            )
            
            logoImageView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide).inset(25)
                $0.centerX.equalToSuperview()
            }
            
            closeButton.snp.makeConstraints {
                $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(25)
            }
            
            popCornImageView.snp.makeConstraints {
                $0.top.equalTo(logoImageView.snp.bottom).offset(50)
                $0.centerX.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(popCornImageView.snp.bottom).offset(25)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.2)
            }
            
            filmStripLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(25)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.2)
            }
            
            tiketLabel.snp.makeConstraints {
                $0.top.equalTo(filmStripLabel.snp.bottom).offset(25)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.2)
            }
            
            okLabel.snp.makeConstraints {
                $0.top.equalTo(tiketLabel.snp.bottom).offset(25)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.2)
            }
            
            subscribeButton.snp.makeConstraints {
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(14)
                $0.top.equalTo(okLabel.snp.bottom).offset(25)
                $0.height.equalTo(50)
            }
            
            cancelSubscribeLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(subscribeButton.snp.bottom).offset(15)
            }
            
            termsLabel.snp.makeConstraints {
                $0.top.equalTo(cancelSubscribeLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(20)
            }
            
            if state == .welcome {
                signInButton.snp.makeConstraints {
                    $0.height.equalTo(subscribeButton.snp.height)
                }
            }
            
            restorePurchaseButton.snp.makeConstraints {
                $0.height.equalTo(subscribeButton.snp.height)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(termsLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(14)
                $0.bottom.equalToSuperview().inset(20)
            }
        }
    }
    
    func checkRotate() {
        if UIDevice.current.orientation.isLandscape {
            popCornImageViewTopLandscape?.activate()
            popCornImageViewTop?.deactivate()
            titleLableTopLandscape?.activate()
            titleLableTop?.deactivate()
            mainStackViewTopLandscape?.activate()
            mainStackViewTop?.deactivate()
        } else {
            popCornImageViewTopLandscape?.deactivate()
            popCornImageViewTop?.activate()
            titleLableTopLandscape?.deactivate()
            titleLableTop?.activate()
            mainStackViewTopLandscape?.deactivate()
            mainStackViewTop?.activate()
        }
        
        termsLabel.attributedText = StoreKitService.shared.attributedTerms(price: price)
    }
    
    func setPriceText(price: String) {
        subscribeButton.buttonTitle = StoreKitService.shared.callToAction(price: price)
        tiketLabel.text = UIDevice.current.userInterfaceIdiom == .pad ? "Безлимитный доступ" : "Безлимитный доступ 7 дней бесплатно,\nдалее \(price) в месяц"
        termsLabel.attributedText = StoreKitService.shared.attributedTerms(price: price)
        self.layoutIfNeeded()
        
        self.price = price
    }
    
    @objc
    private func onTermsLinkTap(sender: UIButton) {
        delegate?.secondTourPayViewDidClickTerms(self)
    }
    
    @objc
    private func onCloseButtonTap(sender: UIButton) {
        delegate?.secondTourPayViewDidClickClose(self)
    }
    
    @objc
    private func onSubscribeButtonTap(sender: UIButton) {
        delegate?.secondTourPayViewDidClickSubscribe(self)
    }
    
    @objc
    private func onSignInButtonTap(sender: UIButton) {
        delegate?.secondTourPayViewDidClickSignIn(self)
    }
    
    @objc
    private func onRestorePurchaseButtonTap(sender: UIButton) {
        delegate?.secondTourPayViewDidClickRestorePurchase(self)
    }
}
