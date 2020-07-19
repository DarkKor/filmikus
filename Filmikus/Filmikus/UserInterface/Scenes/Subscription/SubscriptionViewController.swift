//
//  SubscriptionViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 03.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

extension Notification.Name {
	static let userDidSubscribe = Notification.Name("userSubscribed")
}

class SubscriptionViewController: ViewController {
	
	private let storeKitService: StoreKitServiceType = StoreKitService.shared
					
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "xmark"), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
		return button
	}()
	
	private lazy var mainStackView: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [
			logoImageView, titleLabel, segmentControl, priceDescriptionLabel, continueButton, subscriptionDescriptionLabel
		])
		stack.spacing = 10
		stack.axis = .vertical
		return stack
	}()
	
	private lazy var logoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "logo")
		imageView.contentMode = .center
		return imageView
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .boldSystemFont(ofSize: 20)
		label.text = "Попробуй бесплатно"
		return label
	}()
	
	private lazy var segmentControl: SubscriprionSegmentControl = {
		let segment = SubscriprionSegmentControl()
		segment.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
		return segment
	}()
	
	private lazy var priceDescriptionLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.white.withAlphaComponent(0.4)
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Попробуйте в течение 7 дней бесплатно, а затем цена составит 499 Р в месяц. Оплата раз в год. Отменяйте в любое время."
		return label
	}()
	
	private lazy var continueButton = BlueButton(title: "Продолжить", target: self, action: #selector(onContinueButtonTap))
	
	private lazy var subscriptionDescriptionLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.white.withAlphaComponent(0.4)
		label.font = .systemFont(ofSize: 8)
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Подписка автоматически продлевается, если автопродление не будет отключено по крайней мере за 24 часа до окончания текущего периода. Для управления подпиской и отключения автоматического продления вы можете перейти в настройки iTunes. Деньги будут списаны со счета с вашего аккаунта iTunes при подтверждении покупки. Если вы оформите подписку до истечения срока бесплатной пробной версии, оставшаяся часть бесплатного пробного периода будет аннулирована в момент подтверждения покупки."
		return label
	}()
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = UIColor.gradient(from: .appPeach, to: .appViolet)
		view.addSubview(closeButton)
		view.addSubview(mainStackView)

		closeButton.setContentHuggingPriority(.required, for: .vertical)
		closeButton.snp.makeConstraints {
			$0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
		mainStackView.snp.makeConstraints {
			$0.top.equalTo(closeButton.snp.bottom)
			$0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		showActivityIndicator()
		storeKitService.loadProducts { [weak self] (result) in
			guard let self = self else { return }
			self.hideActivityIndicator()
			guard let products = try? result.get() else { return }
			let segments: [String] = products.map {
				var result: String = ""
				guard let period = $0.subscriptionPeriod else { return result }
				result += "\(period.numberOfUnits)\n"
				switch period.unit {
				case .day:
					result += "день\n"
				case .week:
					result += "неделя\n"
				case .month:
					result += "месяц\n"
				case .year:
					result += "год\n"
				@unknown default:
					break
				}
				result += "\($0.price) RUB"
				return result
			}
			segments.forEach(self.segmentControl.insert)
		}		
    }

	@objc
	private func onCloseButtonTap(sender: UIButton) {
		dismiss(animated: true)
	}
	
	@objc
	private func segmentControlChanged(sender: SubscriprionSegmentControl) {
		print(sender.selectedIndex)
	}
	
	@objc
	private func onContinueButtonTap(sender: UIButton) {
		showActivityIndicator()
		storeKitService.loadProducts { (result) in
			guard let products = try? result.get() else { return }
			let selectedProduct = products[self.segmentControl.selectedIndex]
			
			self.storeKitService.purchase(product: selectedProduct) { [weak self] result in
				guard let self = self else { return }
				self.hideActivityIndicator()
				switch result {
				case .success:
					NotificationCenter.default.post(name: .userDidSubscribe, object: nil)
					self.showAlert(
						title: "Фильмикус",
						message: "Вы успешно подписались!",
						completion: { self.dismiss(animated: true) }
					)
				case .failure(let error):
					self.showAlert(
						title: "Фильмикус",
						message: "Ошибка: \(error.localizedDescription)",
						completion: { self.dismiss(animated: true) }
					)
				}
			}
		}
		
	}
}
