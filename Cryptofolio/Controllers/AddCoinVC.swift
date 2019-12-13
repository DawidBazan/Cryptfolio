//
//  CoinAmountVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 04/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class AddCoinVC: UIViewController {
    
    @IBOutlet var amountField: UITextField!
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinSymbolLbl: UILabel!
    @IBOutlet var addBtn: UIButton!

    var viewModel: AddCoinViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func viewSetup() {
        setSelectedCoin()
        amountField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        amountField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange() {
        guard let text = amountField.text else { return }
        if text.isEmpty {
            addBtn.isEnabled = false
        } else {
            addBtn.isEnabled = true
        }
    }
    
    @IBAction func coinSelectionPressed(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        guard let coin = viewModel.getSelectedCoin(), let amount = amountField.text else { return }
        CoreDataHandler.addCoin(coin, amount: amount)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setSelectedCoin() {
        updateCoin()
        viewModel.updatedSelection = { [weak self] in
            self?.updateCoin()
        }
    }
    
    func updateCoin() {
        guard let selectedCoin = viewModel.getSelectedCoin() else { return }
        coinImageView.image = UIImage(named: "\(selectedCoin.id)")
        coinSymbolLbl.text = selectedCoin.symbol
    }
    
    func showActionSheet() {
        guard viewModel.getCountForActionSheet() > 0 else { return }
        let alert = UIAlertController(title: "", message: "Choose cryptocurrency:", preferredStyle: .actionSheet)

        let indexCount = viewModel.getCountForActionSheet() - 1
        for index in 0...indexCount {
            let coin = viewModel.getCoin(at: index)
            alert.addAction(UIAlertAction(title: coin.symbol, style: .default, handler: { [weak self] _ in
                self?.viewModel.setSelectedCoin(to: coin)
                self?.updateCoin()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Other", style: .default, handler: { [weak self] _ in
            self?.performSegue(withIdentifier: "coinSelection", sender: self)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "coinSelection" {
            if let viewController = segue.destination as? CoinSelectionVC {
                viewController.viewModel = viewModel.createCoinSelectionVM()
            }
        }
    }
}
