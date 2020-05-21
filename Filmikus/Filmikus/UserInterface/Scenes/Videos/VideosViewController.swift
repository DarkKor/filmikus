//
//  VideosViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 13.05.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
	
	private lazy var scrollView = UIScrollView()
	private lazy var containerView = UIView()
	
	private lazy var segmentControl: UnderlinedSegmentControl = {
		let segment = UnderlinedSegmentControl(buttons: [
			"Все видео", "Авто-шоу", "Lifestyle", "Красота", "Мода"
		])
		segment.delegate = self
		return segment
	}()

	private lazy var videoCategoriesViewController: VideoCategoriesViewController = {
		let viewController = VideoCategoriesViewController()
		viewController.delegate = self
		viewController.collectionView.isScrollEnabled = false
		return viewController
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .appLightGray
		
		view.addSubview(scrollView)
		scrollView.addSubview(containerView)
		
		containerView.addSubview(segmentControl)
		addChild(videoCategoriesViewController)
		containerView.addSubview(videoCategoriesViewController.view)
		videoCategoriesViewController.didMove(toParent: self)
		
		scrollView.showsVerticalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		let frameGuide = scrollView.frameLayoutGuide
		let contentGuide = scrollView.contentLayoutGuide
		
		frameGuide.snp.makeConstraints {
			$0.edges.equalTo(view)
			$0.width.equalTo(contentGuide)
		}
		
		containerView.snp.makeConstraints {
			$0.edges.equalTo(contentGuide)
		}
		
		segmentControl.snp.makeConstraints {
			$0.top.left.right.equalToSuperview()
		}
		
		videoCategoriesViewController.view.snp.makeConstraints {
			$0.top.equalTo(segmentControl.snp.bottom)
			$0.left.right.bottom.equalToSuperview()
			$0.height.equalTo(100)
//			$0.edges.equalToSuperview()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Видео"
		
		let videoCategories = [
			VideoCategory(imageUrl: "https://filmikus.com/images/3/1/middle/img.jpg", title: "Тест драйв"),
			VideoCategory(imageUrl: "https://filmikus.com/images/3/6/middle/img.jpg", title: "Мода"),
			VideoCategory(imageUrl: "https://filmikus.com/images/3/7/middle/img.jpg", title: "Стань красивой"),
			VideoCategory(imageUrl: "https://filmikus.com/images/3/8/middle/img.jpg", title: "Простые советы"),
			VideoCategory(imageUrl: "https://filmikus.com/images/3/9/middle/img.jpg", title: "Мода S"),
			VideoCategory(imageUrl: "https://filmikus.com/images/3/10/middle/img.jpg", title: "Star fashion")
		]
		
		videoCategoriesViewController.update(categories: videoCategories)
    }
    
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		let filmsHeight = videoCategoriesViewController.collectionView.contentSize.height
		if filmsHeight > 0 {
			videoCategoriesViewController.view.snp.updateConstraints {
				$0.height.equalTo(filmsHeight)
			}
		}
		scrollView.contentSize.height = filmsHeight + segmentControl.frame.height
	}
}

// MARK: - UnderlinedSegmentControlDelegate

extension VideosViewController: UnderlinedSegmentControlDelegate {
	
	func underlinedSegmentControl(_ control: UnderlinedSegmentControl, didChangeSelectedIndex index: Int) {
		print(control.buttons[index].title(for: .normal))
	}
}


// MARK: - VideoCategoriesViewControllerDelegate

extension VideosViewController: VideoCategoriesViewControllerDelegate {
	
	func videoCategoriesViewController(_ viewController: VideoCategoriesViewController, didSelectCategory category: VideoCategory) {
//		let detailFilmVC = DetailFilmViewController(film: film)
//		navigationController?.pushViewController(detailFilmVC, animated: true)
	}
}
