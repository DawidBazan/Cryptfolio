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
    
    var viewModel: CoinInfoViewModel!
    var coinChanged: ((CoinChange) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.setupChart(with: viewModel.getPriceChanges(), showLines: true)
        setupButtons()
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
    
    @IBAction func actionPressed(_ sender: Any) {
        switch actionBtn.title(for: .normal) {
        case "Edit":
            actionAlert(message: "Edit coin amount", action: "Update")
        case "Add":
            actionAlert(message: "Enter coin amount", action: "Add")
        default:
            break
        }
    }
    
    func actionAlert(message: String, action: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "New amount"
            textField.keyboardType = .decimalPad
        })
        alert.addAction(UIAlertAction(title: action, style: .default, handler: { _ in
            guard let text = alert.textFields?.first?.text else { return }
            guard let newAmount = Double(text) else { return }
            if newAmount > 0 {
                if action == "Update" {
                    let changedAmount = self.viewModel.changeCoinAmount(newAmount)
                    self.coinChanged?(changedAmount)
                } else {
                    let addCoin = self.viewModel.addCoin(with: newAmount)
                    self.coinChanged?(addCoin)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Delete coin from portfolio?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            let deleteCoin = self.viewModel.deleteCoin()
            self.coinChanged?(deleteCoin)
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

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
