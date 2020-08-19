//
//  LoadContentsViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 18.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

protocol LoadContentsViewControllerDelegate: class {
    func loadContentsViewControllerAnimationDidStop(_ viewController: LoadContentsViewController)
    func loadContentsViewControllerAnimationDidOpenPay(_ viewController: LoadContentsViewController)
}

class LoadContentsViewController: ViewController {
    
    weak var delegate: LoadContentsViewControllerDelegate?
    
    private var genresLabelBottomConstraint: Constraint?
    private var countryesLabelBottomConstraint: Constraint?
    private var searchFilmLabelBottomConstraint: Constraint?
    
    private lazy var loadImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.setContentHuggingPriority(.required, for: .vertical)
        return img
    }()
    
    private lazy var genresLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.alpha = 0
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        lbl.text = "Подбираем выбранные жанры"
        return lbl
    }()
    
    private lazy var countryesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.alpha = 0
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        lbl.text = "Подбираем выбранные страны"
        return lbl
    }()
    
    private lazy var searchFilmLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.alpha = 0
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .regular)
        }
        lbl.text = "Найдено фильмов"
        return lbl
    }()
    
    private lazy var filmsCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = String(Int.random(in: 1000...2000))
        lbl.alpha = 0
        if traitCollection.userInterfaceIdiom == .pad {
            lbl.font = .systemFont(ofSize: 36, weight: .regular)
        } else {
            lbl.font = .systemFont(ofSize: 24, weight: .regular)
        }
        return lbl
    }()
    

    override func loadView() {
        view = UIView()
        
        view.addSubviews(
            loadImageView,
            genresLabel,
            countryesLabel,
            searchFilmLabel,
            filmsCountLabel
        )
        
        loadImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.centerY.equalToSuperview()
            } else {
               $0.top.equalToSuperview()
            }
        }
        
        genresLabel.snp.makeConstraints {
            genresLabelBottomConstraint = $0.bottom.equalToSuperview().constraint
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.2)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(loadImageView.snp.bottom).offset(60).priority(.low)
            } else {
                $0.top.equalTo(loadImageView.snp.bottom).offset(20).priority(.low)
            }
        }
        
        countryesLabel.snp.makeConstraints {
            countryesLabelBottomConstraint = $0.bottom.equalToSuperview().constraint
            
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.2)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.greaterThanOrEqualTo(loadImageView.snp.bottom).offset(100).priority(.low)
            } else {
                $0.top.greaterThanOrEqualTo(loadImageView.snp.bottom).offset(60).priority(.low)
            }
        }
        
        searchFilmLabel.snp.makeConstraints {
            searchFilmLabelBottomConstraint = $0.bottom.equalToSuperview().constraint
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.2)
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.greaterThanOrEqualTo(loadImageView.snp.bottom).offset(140).priority(.low)
            } else {
                $0.top.greaterThanOrEqualTo(loadImageView.snp.bottom).offset(100).priority(.low)
            }
        }

        filmsCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(searchFilmLabel.snp.bottom).offset(15)
            } else {
                $0.top.equalTo(searchFilmLabel.snp.bottom).offset(5)
            }
        }
    }
    
    func loadFilms() {
        loadImageView.loadGif(name: "BlueCat")
        genresLabelBottomConstraint?.deactivate()
        UIView.animate(
            withDuration: 0.25,
            delay: 1,
            options: .curveLinear,
            animations: {
                self.genresLabel.alpha = 1
                self.view.layoutIfNeeded()
        },
            completion:  { _ in
                self.countryesLabelBottomConstraint?.deactivate()
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    options: .curveLinear,
                    animations: {
                        self.countryesLabel.alpha = 1
                        self.view.layoutIfNeeded()
                },
                    completion: { _ in
                        self.searchFilmLabelBottomConstraint?.deactivate()
                        UIView.animate(
                            withDuration: 0.5,
                            delay: 0,
                            options: .curveLinear,
                            animations: {
                                self.searchFilmLabel.alpha = 1
                                self.view.layoutIfNeeded()
                        },
                            completion: { _ in
                                UIView.animate(
                                    withDuration: 1,
                                    animations: {
                                        self.filmsCountLabel.alpha = 1
                                },
                                    completion: { _ in
                                        self.loadImageView.isHidden = true
                                        self.delegate?.loadContentsViewControllerAnimationDidStop(self)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.delegate?.loadContentsViewControllerAnimationDidOpenPay(self)
                                        }
                                })
                        })
                })
        })
    }
}

