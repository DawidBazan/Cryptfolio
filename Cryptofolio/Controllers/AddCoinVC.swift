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
    @IBOutlet var coinSymbolLbl: UILabel!
    @IBOutlet var addBtn: UIButton!
    
    var crypto: [CoinInfo]?
    var selectedCoin: CoinInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func viewSetup() {
        guard let crypto = crypto else { return }
        coinSymbolLbl.text = crypto.first?.symbol
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
        guard let coin = selectedCoin, let amount = amountField.text else { return }
        CoreDataHandler.addCoin(coin, amount: amount)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectCrypto(coin: CoinInfo) {
        selectedCoin = coin
        coinSymbolLbl.text = coin.symbol
    }
    
    func showActionSheet() {
        guard let crypto = crypto, crypto.count > 3 else { return } // will be 0 until viewModel setup
        let alert = UIAlertController(title: "", message: "Choose cryptocurrency:", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: crypto[0].symbol, style: .default, handler: { _ in
            self.selectCrypto(coin: crypto[0])
        }))

        alert.addAction(UIAlertAction(title: crypto[1].symbol, style: .default, handler: { _ in
            self.selectCrypto(coin: crypto[1])
        }))

        alert.addAction(UIAlertAction(title: crypto[2].symbol, style: .default, handler: { _ in
            self.selectCrypto(coin: crypto[2])
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .default, handler: { _ in
            print("User click Delete button")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
