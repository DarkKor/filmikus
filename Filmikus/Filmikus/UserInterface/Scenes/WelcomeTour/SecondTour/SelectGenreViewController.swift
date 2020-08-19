//
//  SelectGenreViewController.swift
//  Filmikus
//
//  Created by Алесей Гущин on 17.08.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

protocol SelectGenreViewControllerDelegate: class {
    func selectGenreViewController(_ viewController: ViewController, selectedRowsCount: Int?)
}

class SelectGenreViewController: ViewController {

    weak var delegate: SelectGenreViewControllerDelegate?
    
    private let genres = [
        "Триллер, детектив, криминал",
        "Ужасы",
        "Фантастика, фэнтези",
        "Экшн, приключения",
        "Мюзикл",
        "Комедия, мелодрама",
        "Драма, мелодрама",
        "Документальное"
    ]
    
    private var selectedRowCount: Int? {
        genreCollectionView.indexPathsForSelectedItems?.count
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
        lbl.text = "Выбери любимые жанры"
        return lbl
    }()
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 9
        return layout
    }()
    
    private lazy var genreCollectionView: UICollectionView = {
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
        view.addSubviews(titleLabel, genreCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(1.2)
        }
        
        genreCollectionView.snp.makeConstraints {
            if traitCollection.userInterfaceIdiom == .pad {
                $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            } else {
                $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            }
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        delegate?.selectGenreViewController(self, selectedRowsCount: selectedRowCount)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: { _ in self.genreCollectionView.collectionViewLayout.invalidateLayout() },
            completion: { _ in }
        )
    }
}

// MARK: - UICollectionViewDataSource

extension SelectGenreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SecondTourReuseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let genre = genres[indexPath.row]
        cell.text = genre
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SelectGenreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        
        let widthPerItem = collectionView.bounds.width / 2 - layout.minimumInteritemSpacing
        let heightPerItem = collectionView.bounds.height / CGFloat(genres.count / 2) - layout.minimumLineSpacing
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectGenreViewController(self, selectedRowsCount: selectedRowCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.selectGenreViewController(self, selectedRowsCount: selectedRowCount)
    }
}
