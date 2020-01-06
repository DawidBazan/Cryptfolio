//
//  CoinInfoVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinInfoVC: UIViewController {
	@IBOutlet var chartView: ChartView!
	@IBOutlet var actionBtn: CustomButton!
	@IBOutlet var deleteBtn: CustomButton!
	@IBOutlet var priceLbl: UILabel!
	@IBOutlet var priceChangeLbl: UILabel!

	var viewModel: CoinInfoViewModel!
	var coinChanged: ((CoinChange) -> Void)?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}

	func setupView() {
		navigationItem.title = viewModel.getCoinName()
		chartView.setupChart(with: viewModel.getPriceHistory(), showLines: true)
		addChartTapRecognizer()
		setPriceLabels()
		setupButtons()
	}

	func setPriceLabels() {
		priceLbl.text = viewModel.getCoinPrice()
		let priceChange = viewModel.getCoinPriceChange()
		if priceChange.first == "-" {
			priceChangeLbl.textColor = Constant.Colors.primaryRed
			priceChangeLbl.text = priceChange
		} else {
			priceChangeLbl.textColor = Constant.Colors.primaryGreen
			priceChangeLbl.text = "+\(priceChange)"
		}
	}

	func setupButtons() {
		if viewModel.isCoinInPortfolio() {
			actionBtn.setTitle("Edit", for: .normal)
			deleteBtn.isHidden = false
		} else {
			actionBtn.setTitle("Add", for: .normal)
			deleteBtn.isHidden = true
		}
	}

	func addChartTapRecognizer() {
		let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chartTapped))
		tapRecognizer.minimumPressDuration = 0.0
		chartView.addGestureRecognizer(tapRecognizer)
	}

	@objc func chartTapped(_ sender: UITapGestureRecognizer) {
		if sender.state == .began || sender.state == .changed {
			// show
			let position = sender.location(in: chartView)
			let highlight = chartView.getHighlightByTouchPoint(position)
			let entry = chartView.getEntryByTouchPoint(point: position)
			chartView.highlightValue(highlight)
			guard let index = entry?.x else { return }
			priceLbl.text = viewModel.getPriceForIndex(Int(index))
			priceChangeLbl.isHidden = true
			if Int(position.x) % 2 == 0 {
				Constant.hapticFeedback(style: .light)
			}
		} else {
			// hide
			chartView.highlightValue(nil)
			priceLbl.text = viewModel.getCoinPrice()
			priceChangeLbl.isHidden = false
		}
	}

	@IBAction func actionPressed(_ sender: Any) {
		Constant.hapticFeedback(style: .medium)
		switch actionBtn.title(for: .normal) {
		case "Edit":
			presentEditAlert { [weak self] newAmount in
				let changedAmount = CoinChange(amount: newAmount)
				self?.coinChanged?(changedAmount)
			}
		case "Add":
			presentAddAlert { [weak self] amount in
				let addCoin = CoinChange(amount: amount, add: true)
				self?.coinChanged?(addCoin)
				self?.navigationController?.popViewController(animated: true)
			}
		default:
			break
		}
	}

	@IBAction func deletePressed(_ sender: Any) {
		Constant.hapticFeedback(style: .medium)
		presentDeleteAlert { [weak self] in
			let deleteCoin = CoinChange(delete: true)
			self?.coinChanged?(deleteCoin)
			self?.navigationController?.popViewController(animated: true)
		}
	}
}

// MARK: - TableView Delegates

extension CoinInfoVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getRowCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CoinInfoCell
		let info = viewModel.getCoinInfo(at: indexPath.row)
		let title = viewModel.getTitle(for: indexPath.row)
		cell.setupCell(with: info, for: title)
		return cell
	}
}
