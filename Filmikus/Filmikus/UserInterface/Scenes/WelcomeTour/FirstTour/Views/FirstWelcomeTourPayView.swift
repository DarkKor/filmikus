//
//  FirstWelcomeTourPayView.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol FirstWelcomeTourPayViewDelegate: class {
    func firstWelcomeTourPayViewDidClickSignIn(_ view: FirstWelcomeTourPayView)
    func firstWelcomeTourPayViewDidClickSubscribe(_ view: FirstWelcomeTourPayView)
    func firstWelcomeTourPayViewDidClickRestorePurchase(_ view: FirstWelcomeTourPayView)
    func firstWelcomeTourPayViewDidClickClose(_ view: FirstWelcomeTourPayView)
}

class FirstWelcomeTourPayView: UIView {
    
    weak var delegate: FirstWelcomeTourPayViewDelegate?
    
    private var thirdScreenWidht: CGFloat = UIScreen.main.bounds.width / 3
    private var halfScreenWidht: CGFloat = UIScreen.main.bounds.width / 2
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var firstStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            filmStripImageViewContainer,
            filmStripTextView
        ])
        if traitCollection.userInterfaceIdiom == .pad {
            stv.spacing = 30
        } else {
            stv.spacing = 10
        }
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var secondStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            tiketImageViewContainer,
            tiketTextView
        ])
        if traitCollection.userInterfaceIdiom == .pad {
            stv.spacing = 30
        } else {
            stv.spacing = 10
        }
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var thirdStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            okImageViewContainer,
            okTextView
        ])
        if traitCollection.userInterfaceIdiom == .pad {
            stv.spacing = 30
        } else {
            stv.spacing = 10
        }
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
        stv.spacing = 25
        stv.axis = .vertical
        return stv
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            signInButton,
            restorePurchaseButton
        ])
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
        imageView.image = UIImage(named: "filmStrip")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private lazy var filmStripTextView: UITextView = {
        let vTxt = UITextView()
        vTxt.textColor = .white
        vTxt.backgroundColor = .clear
        vTxt.isUserInteractionEnabled = false
        vTxt.isScrollEnabled = false
        vTxt.text = "Более 5000 фильмов, сериалов, популярного контента"
        if traitCollection.userInterfaceIdiom == .pad {
            vTxt.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            vTxt.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return vTxt
    }()
    
    private lazy var tiketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tiket")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private lazy var tiketTextView: UITextView = {
        let vTxt = UITextView()
        vTxt.textColor = .white
        vTxt.backgroundColor = .clear
        vTxt.isUserInteractionEnabled = false
        vTxt.isScrollEnabled = false
        vTxt.text = "Безлимитный доступ за 349 Р в месяц"
        if traitCollection.userInterfaceIdiom == .pad {
            vTxt.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            vTxt.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return vTxt
    }()
    
    private lazy var okImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ok")
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var okTextView: UITextView = {
        let vTxt = UITextView()
        vTxt.textColor = .white
        vTxt.backgroundColor = .clear
        vTxt.isUserInteractionEnabled = false
        vTxt.isScrollEnabled = false
        vTxt.text = "Без рекламы"
        if traitCollection.userInterfaceIdiom == .pad {
            vTxt.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            vTxt.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return vTxt
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.text = "Смотри первые 7 дней бесплатно"
        lbl.textAlignment = .center
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 36, weight: .semibold)
        } else {
            lbl.font = .systemFont(ofSize: 24, weight: .semibold)
        }
        return lbl
    }()
    
    private lazy var subscribeButton = ColoredBorderButton(
        title: "Смотреть бесплатно",
        color: UIColor.gradient(from: .appGLightBlue, to: .appBlue, direction: .vertical),
        borderColor: .appLightBlueBorder,
        target: self,
        action: #selector(onSubscribeButtonTap)
    )
    
    private lazy var cancelSubscribeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 14, weight: .regular)
        }
        lbl.text = "Отменить подписку можно в любой момент"
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
        lbl.textAlignment = .justified
        lbl.font = .systemFont(ofSize: 9, weight: .regular)
        lbl.text = "Подписка автоматически продлится, если автопродление не будет отключено по крайней мере за 24 часа до окончания текущего периода. Для управления подпиской и отключения автоматического продления вы можете перейти в настройки  iTunes. Деньги будут списаны со счета вашего аккаунта iTunes при подтверждении покупки. Если вы оформите подписку до истечения срока бесплатной пробной версии, оставшаяся часть бесплатного пробного периода будет аннулирована в момент подтверждения покупки"
        return lbl
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews(
            logoImageView,
            closeButton,
            titleLabel,
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
            if traitCollection.userInterfaceIdiom == .pad {
                $0.width.equalTo(110)
                $0.height.equalTo(110)
            } else {
                $0.width.equalTo(66)
                $0.height.equalTo(66)
            }
        }
        
        filmStripImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        tiketImageViewContainer.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.width.equalTo(110)
                $0.height.equalTo(110)
            } else {
                $0.width.equalTo(66)
                $0.height.equalTo(66)
            }
        }
        
        tiketImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        okImageViewContainer.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.width.equalTo(110)
                $0.height.equalTo(110)
            } else {
                $0.width.equalTo(66)
                $0.height.equalTo(66)
            }
        }
        
        okImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(25)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(logoImageView.snp.bottom).offset(25)
                $0.centerX.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(50)
            } else {
                $0.top.equalTo(logoImageView.snp.bottom).offset(58)
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(25)
            }
        }
        
        mainStackView.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(titleLabel.snp.bottom).offset(50)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(1.2)
            } else {
                $0.top.equalTo(titleLabel.snp.bottom).offset(61)
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(14)
            }
        }
        
        subscribeButton.snp.makeConstraints {
            $0.height.equalTo(50)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(halfScreenWidht)
                $0.top.equalTo(mainStackView.snp.bottom).offset(40)
            } else {
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(14)
                $0.top.equalTo(mainStackView.snp.bottom).offset(50)
            }
        }
        
        cancelSubscribeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(subscribeButton.snp.bottom).offset(20)
            } else {
                $0.top.equalTo(subscribeButton.snp.bottom).offset(15)
            }
        }
        
        signInButton.snp.makeConstraints {
            $0.height.equalTo(subscribeButton.snp.height)
        }
        
        restorePurchaseButton.snp.makeConstraints {
            $0.height.equalTo(subscribeButton.snp.height)
        }
        
        buttonStackView.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.greaterThanOrEqualTo(cancelSubscribeLabel.snp.bottom).offset(50)
                $0.centerX.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(50)
            } else {
                $0.top.equalTo(cancelSubscribeLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(14)
            }
        }
        
        termsLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
             if traitCollection.userInterfaceIdiom == .pad {
             } else {
                $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(20)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(isLandscape: Bool) {
        if isLandscape {
            firstStackView.axis = .vertical
            secondStackView.axis = .vertical
            thirdStackView.axis = .vertical
            mainStackView.axis = .horizontal
            filmStripTextView.textAlignment = .center
            tiketTextView.textAlignment = .center
            okTextView.textAlignment = .center
            mainStackView.distribution = .fillEqually
        } else {
            firstStackView.axis = .horizontal
            secondStackView.axis = .horizontal
            thirdStackView.axis = .horizontal
            mainStackView.axis = .vertical
            filmStripTextView.textAlignment = .left
            tiketTextView.textAlignment = .left
            okTextView.textAlignment = .left
            mainStackView.distribution = .fill
        }
    }
    
    
    @objc
    private func onSubscribeButtonTap(sender: UIButton) {
        delegate?.firstWelcomeTourPayViewDidClickSubscribe(self)
    }
    
    @objc
    private func onSignInButtonTap(sender: UIButton) {
        delegate?.firstWelcomeTourPayViewDidClickSignIn(self)
    }
    
    @objc
    private func onRestorePurchaseButtonTap(sender: UIButton) {
        delegate?.firstWelcomeTourPayViewDidClickRestorePurchase(self)
    }
    
    @objc
    private func onCloseButtonTap(sender: UIButton) {
        delegate?.firstWelcomeTourPayViewDidClickClose(self)
    }
    
}
