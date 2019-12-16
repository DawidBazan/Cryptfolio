//
//  HistoryCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var cryptoImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var fullNameLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var changeLbl: UILabel!
    @IBOutlet var changeView: UIView!
    
    func setupCell(with coin: CoinInfo, change: Double) {
        cryptoImage.image = UIImage(named: "\(coin.id)")
        nameLbl.text = coin.symbol
        fullNameLbl.text = coin.name
        amountLbl.text = "\(coin.amount)"
        priceLbl.text = UnitFormatter.currency(from: coin.buyPrice)
        setChangeLbl(with: change)
    }
    
    private func setChangeLbl(with value: Double) {
        changeView.layer.cornerRadius = changeView.frame.height / 2
        let percentage = UnitFormatter.percentage(from: value)
        if value > 0 {
            changeLbl.textColor = #colorLiteral(red: 0.2078431373, green: 0.8745098039, blue: 0.4352941176, alpha: 1)
            changeView.backgroundColor = #colorLiteral(red: 0.92146945, green: 0.988289535, blue: 0.9449847937, alpha: 1)
            changeLbl.text = String("+\(percentage)")
        } else if value == 0 {
            changeLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            changeView.backgroundColor = #colorLiteral(red: 0.9489305615, green: 0.9490671754, blue: 0.9693607688, alpha: 1)
            changeLbl.text = percentage
        } else {
            changeLbl.textColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1)
            changeView.backgroundColor = #colorLiteral(red: 0.9920850396, green: 0.933385551, blue: 0.9293023944, alpha: 1)
            changeLbl.text = percentage
        }
    }
}
