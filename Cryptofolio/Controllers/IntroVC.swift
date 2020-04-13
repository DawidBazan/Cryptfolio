//
//  IntroVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 17/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
	var viewModel: IntroViewModel!
    let contentView = IntroView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

	func setupView() {
        
        // Static text
        contentView.titleLabel.text = "Pick your coins"
        contentView.descriptionLabel.text = "Select the coin that you would like to track."
            
        contentView.doneButton.addTarget(self, action: #selector(donePressed(_:)), for: .touchUpInside)
        contentView.tableView.register(IntroCell.self, forCellReuseIdentifier: "cell")
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
		viewModel.updatedCrypto = { [weak self] in
            self?.contentView.tableView.reloadData()
			self?.contentView.tableView.isEditing = true
		}
	}

	@objc func donePressed(_ sender: Any) {
        guard let selectedIndexes = contentView.tableView.indexPathsForSelectedRows else { return }
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
        let coin = viewModel.getCoin(at: indexPath.row).asPresentable
        cell.setupCell(with: coin.name, amount: coin.amount)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Constant.hapticFeedback(style: .light)
		presentAddAlert { [weak self] amount in
			self?.viewModel.addCoinAmount(amount, at: indexPath.row)
            self?.contentView.tableView.reloadRows(at: [indexPath], with: .automatic)
            self?.contentView.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self?.contentView.doneButton.isEnabled = true
		}
	}
}
