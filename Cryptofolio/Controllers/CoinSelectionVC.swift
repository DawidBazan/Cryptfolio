//
//  AddCoinVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 27/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinSelectionVC: UIViewController {
	@IBOutlet var tableView: UITableView!

	var viewModel: CoinSelectionViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func donePressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - TableView Delegates

extension CoinSelectionVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getRowCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CoinSelectionCell
		let coin = viewModel.getCoin(at: indexPath.row)
		cell.setupCell(with: coin)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Constant.hapticFeedback(style: .light)
		let coin = viewModel.getCoin(at: indexPath.row)
		viewModel.updateSelectedCoin(coin)
		dismiss(animated: true, completion: nil)
	}
}
