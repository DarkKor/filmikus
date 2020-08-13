//
//  FirstWelcomeTourPayView.swift
//  Filmikus
//
//  Created by Алесей Гущин on 13.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class FirstWelcomeTourPayView: UIView {
    
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
            filmStripImageView,
            filmStripLabel
        ])
        stv.spacing = 10
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var secondStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            tiketImageView,
            tiketLabel
        ])
        stv.spacing = 10
        stv.alignment = .center
        stv.axis = .horizontal
        return stv
    }()
    
    private lazy var thirdStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [
            okImageView,
            okLabel
        ])
        stv.spacing = 10
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
        } else {
            stv.spacing = 6
            stv.axis = .vertical
        }
        return stv
    }()
    
    private lazy var filmStripImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filmStrip")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var filmStripLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = "Более 5000 фильмов, сериалов, популярного контента"
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 26, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return lbl
    }()
    
    private lazy var tiketImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tiket")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var tiketLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = "Безлимитный доступ за 349 Р в месяц"
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 26, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return lbl
    }()
    
    private lazy var okImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ok")
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var okLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = "Без рекламы"
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 26, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        return lbl
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = "Смотри первые 7 дней бесплатно"
        lbl.textAlignment = .center
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        } else {
            lbl.font = .systemFont(ofSize: 24, weight: .semibold)
        }
        return lbl
    }()
    
    private lazy var subscribeButton = BlueButton(
        title: "Смотреть бесплатно",
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
    
    private lazy var signInButton = TranspatentBorderButton(
        title: "Есть аккаунт? Войти",
        target: self,
        action: #selector(onSignInButtonTap)
    )
    
    private lazy var restorePurchaseButton = TranspatentBorderButton(
        title: "Восстановить покупки",
        target: self,
        action: #selector(onRestorePurchaseButtonTap)
    )
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .appPurple
        addSubviews(
            logoImageView,
            closeButton,
            titleLabel,
            mainStackView,
            subscribeButton,
            cancelSubscribeLabel,
            buttonStackView
        )
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(25)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(35)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(thirdScreenWidht)
            } else {
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(25)
            }
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(halfScreenWidht)
            } else {
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(14)
            }
        }
        
        subscribeButton.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(halfScreenWidht)
            } else {
                $0.height.equalTo(55)
                $0.bottom.equalTo(cancelSubscribeLabel.snp.top).offset(-10)
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(14)
                $0.top.greaterThanOrEqualTo(mainStackView.snp.bottom).offset(20)
            }
            
            cancelSubscribeLabel.snp.makeConstraints {
                $0.top.equalTo(buttonStackView.snp.top).offset(-40)
                $0.centerX.equalToSuperview()
            }
            
            signInButton.snp.makeConstraints {
                $0.height.equalTo(subscribeButton.snp.height)
            }
            
            restorePurchaseButton.snp.makeConstraints {
                $0.height.equalTo(subscribeButton.snp.height)
            }
            
            if traitCollection.userInterfaceIdiom == .pad {
                buttonStackView.snp.makeConstraints {
                    $0.top.equalTo(cancelSubscribeLabel.snp.bottom).offset(115)
                    $0.centerX.equalToSuperview()
                    $0.width.equalTo(halfScreenWidht)
                    $0.bottom.lessThanOrEqualTo(100)
                }
            } else {
                buttonStackView.snp.makeConstraints {
                    $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(14)
                    $0.bottom.greaterThanOrEqualTo(self).inset(150)
                }
            }
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc
      private func onSubscribeButtonTap(sender: UIButton) {
          
      }
      
      @objc
      private func onSignInButtonTap(sender: UIButton) {
          
      }
      
      @objc
      private func onRestorePurchaseButtonTap(sender: UIButton) {
          
      }
      
      @objc
      private func onCloseButtonTap(sender: UIButton) {
          
      }
    
}
