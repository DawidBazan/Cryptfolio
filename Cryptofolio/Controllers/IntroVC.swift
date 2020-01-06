//
//  IntroVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 17/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
	@IBOutlet var tableView: UITableView!
	@IBOutlet var doneBtn: UIButton!

	var viewModel: IntroViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}

	func setupView() {
		viewModel.updatedCrypto = { [weak self] in
			self?.tableView.reloadData()
			self?.tableView.isEditing = true
		}
	}

	@IBAction func donePressed(_ sender: Any) {
		guard let selectedIndexes = tableView.indexPathsForSelectedRows else { return }
		let selectedRows = selectedIndexes.map { $0.row }
		viewModel.addSelectedCoins(from: selectedRows)
		Constant.hapticFeedback(style: .heavy)
		performSegue(withIdentifier: "main", sender: self)
	}
}

// MARK: - TableView Delegates

extension IntroVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getRowCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! IntroCell
		let coin = viewModel.getCoin(at: indexPath.row)
		cell.setupCell(with: coin)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Constant.hapticFeedback(style: .light)
		presentAddAlert { [weak self] amount in
			self?.viewModel.addCoinAmount(amount, at: indexPath.row)
			self?.tableView.reloadRows(at: [indexPath], with: .automatic)
			self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
			self?.doneBtn.isEnabled = true
		}
	}
}
