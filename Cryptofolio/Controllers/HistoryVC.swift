//
//  HistoryVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
	var viewModel: HistoryViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

// MARK: - TableView Delegates

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getRowCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryCell
		let coin = viewModel.getCoin(at: indexPath.row)
		let change = viewModel.getPriceChange(for: coin)
		cell.setupCell(with: coin, change: change)
		return cell
	}
}
