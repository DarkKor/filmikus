//
//  SelectItemPickerViewController.swift
//  Filmikus
//
//  Created by Андрей Козлов on 01.06.2020.
//  Copyright © 2020 Андрей Козлов. All rights reserved.
//

import UIKit
import SnapKit

enum SelectedDate {
	case all
	case interval(from: Int, to: Int)
}

class SelectItemPickerViewController: UIViewController {
	
	typealias SelectDateBlock = (SelectedDate) -> Void
	
	private var selectDateBlock: SelectDateBlock
	
	private var items: [Int] = []
	
	private lazy var picker: UIPickerView = {
		let picker = UIPickerView()
		picker.backgroundColor = .white
		picker.dataSource = self
		picker.delegate = self
		return picker
	}()
	
	private lazy var buttonSearch = BlueButton(title: "НАЙТИ", target: self, action: #selector(onButtonSearchTap))
	private lazy var buttonAllYears = BlueButton(title: "ВСЕ ГОДЫ", target: self, action: #selector(onButtonAllYearsTap))

	init(items: [Int], onSelectDate block: @escaping SelectDateBlock) {
		self.items = items
		self.selectDateBlock = block
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		view.addSubview(picker)
		view.addSubview(buttonSearch)
		view.addSubview(buttonAllYears)

		picker.snp.makeConstraints {
			$0.left.right.equalToSuperview().inset(20)
		}
		buttonSearch.snp.makeConstraints {
			$0.top.equalTo(picker.snp.bottom).offset(10)
			$0.left.right.equalToSuperview().inset(20)
			$0.height.equalTo(44)
		}
		buttonAllYears.snp.makeConstraints {
			$0.top.equalTo(buttonSearch.snp.bottom).offset(20)
			$0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
			$0.height.equalTo(44)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		picker.selectRow(items.count - 1, inComponent: 3, animated: false)

		navigationItem.largeTitleDisplayMode = .never

	}
	
	@objc
	private func onButtonSearchTap(sender: UIButton) {
		let fromIndex = picker.selectedRow(inComponent: 1)
		let toIndex = picker.selectedRow(inComponent: 3)
		selectDateBlock(.interval(from: items[fromIndex], to: items[toIndex]))
		navigationController?.popViewController(animated: true)
	}
	
	@objc
	private func onButtonAllYearsTap(sender: UIButton) {
		selectDateBlock(.all)
		navigationController?.popViewController(animated: true)
	}
}

extension SelectItemPickerViewController: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		4
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 0, 2:
			return 1
		case 1, 3:
			return items.count
		default:
			return 0
		}
	}
}


extension SelectItemPickerViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch component {
		case 0:
			return "С"
		case 2:
			return "По"
		case 1, 3:
			return String(items[row])
		default:
			return nil
		}
	}
}
