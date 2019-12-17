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
        let selectedRows = selectedIndexes.map({$0.row})
        viewModel.addSelectedCoins(from: selectedRows)
        self.performSegue(withIdentifier: "main", sender: self)
    }
}

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
        let alert = UIAlertController(title: "", message: "Enter coin amount", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "amount eg. 100"
            textField.keyboardType = .decimalPad
        })
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text else { return }
            if !text.isEmpty {
                guard let amount = Double(text) else { return }
                self.viewModel.addCoinAmount(amount, at: indexPath.row)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
