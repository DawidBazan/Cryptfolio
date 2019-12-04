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
        if let btc = crypto?.filter({$0.symbol == "BTC"}).first {
            coinSymbolLbl.text = btc.symbol
        }
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
        print("Select coin")
    }
    
    @IBAction func addPressed(_ sender: Any) {
        guard let coin = selectedCoin, let amount = amountField.text else { return }
        CoreDataHandler.addCoin(coin, amount: amount)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
