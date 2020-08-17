//
//  SelectCountryOfOriginViewController.swift
//  Filmikus
//
//  Created by Alexey Guschin on 17.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol SelectCountryOfOriginViewControllerDelegate: class {
    func selectCountryOfOriginViewController(_ viewController: ViewController, selectedRowsCount: Int?)
}

class SelectCountryOfOriginViewController: ViewController {
    
    weak var delegate: SelectCountryOfOriginViewControllerDelegate?
    
    private let countryesOfOrigin = [
        "Страны СНГ",
        "Российские, советские",
        "Европейские",
        "США"
    ]
    
    private var selectedRowCount: Int? {
        countiesOfOriginCollectionView.indexPathsForSelectedItems?.count
    }
    
    private lazy var titleLabel: UILabel = {
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
        lbl.text = "Какие фильмы и сериалы ты предпочитаешь?"
        return lbl
    }()
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 9
        return layout
    }()
    
    private lazy var countiesOfOriginCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.allowsMultipleSelection = true
        collection.register(cell: SecondTourReuseCollectionViewCell.self)
        return collection
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        view.addSubviews(titleLabel, countiesOfOriginCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.2)
        }
        
        countiesOfOriginCollectionView.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            } else {
                $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            }
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: { _ in self.countiesOfOriginCollectionView.collectionViewLayout.invalidateLayout() },
            completion: { _ in }
        )
    }
}

// MARK: - UICollectionViewDataSource

extension SelectCountryOfOriginViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryesOfOrigin.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SecondTourReuseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let countryOfOrigin = countryesOfOrigin[indexPath.row]
        cell.text = countryOfOrigin
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectCountryOfOriginViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        
        let widthPerItem = collectionView.bounds.width
        let heightPerItem = collectionView.bounds.height / CGFloat(countryesOfOrigin.count) - layout.minimumLineSpacing
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectCountryOfOriginViewController(self, selectedRowsCount: selectedRowCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.selectCountryOfOriginViewController(self, selectedRowsCount: selectedRowCount)
    }
}
