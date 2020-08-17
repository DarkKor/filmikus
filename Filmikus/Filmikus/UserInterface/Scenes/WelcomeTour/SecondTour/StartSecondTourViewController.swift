//
//  StartSecondTourViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 17.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class StartSecondTourViewController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "welcomeFirst-2"))
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private lazy var lblInfo: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 36, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        }
        lbl.text = "Более чем 5000 фильмов и сериалов"
        return lbl
    }()
    
    private lazy var NextButton = ColoredBorderButton(
        title: "Далее",
        color: UIColor.gradient(from: .appGLightBlue, to: .appBlue, direction: .vertical),
        borderColor: .appLightBlueBorder,
        target: self,
        action: #selector(onNextButtonTap)
    )
    
    override func loadView() {
        view = UIView()
        view.addSubviews(backgroundImage, logoImageView, lblInfo, NextButton)
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(25)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.leading.equalTo(view.safeAreaLayoutGuide).inset(40)
            } else {
                $0.centerX.equalToSuperview()
            }
        }
        
        lblInfo.snp.makeConstraints {
            $0.bottom.equalTo(NextButton.snp.top).offset(-40)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        NextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.height.equalTo(60)
                $0.width.equalToSuperview().dividedBy(2)
            } else {
                $0.height.equalTo(50)
                $0.width.equalToSuperview().dividedBy(1.1)
            }
        }
    }
    
    @objc
    private func onNextButtonTap(sender: UIButton) {
        let containerVC = SecondTourContainerViewController()
        present(containerVC, animated: true)
    }
}
