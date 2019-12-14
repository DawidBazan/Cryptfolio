//
//  CryptoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 10/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CryptoCell: UITableViewCell {

    @IBOutlet var cryptoImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var fullPriceLbl: UILabel!
    @IBOutlet var valueChangeView: UIView!
    @IBOutlet var valueChangeLbl: UILabel!
    
    func setupCell(with info: CoinInfo) {
        if let imageData = info.imageData {
            cryptoImage.image = UIImage(data: imageData)
        }
        nameLbl.text = info.symbol
        fullPriceLbl.text = UnitFormatter.currency(from: info.price) //change to 2 decimal places
        setValueLbl(with: info.percentChange24H)
    }
    
    private func setValueLbl(with value: Double) {
        valueChangeView.layer.cornerRadius = valueChangeView.frame.height / 2
        let percentage = UnitFormatter.percentage(from: value)
        if value > 0 {
            valueChangeLbl.textColor = #colorLiteral(red: 0.2078431373, green: 0.8745098039, blue: 0.4352941176, alpha: 1)
            valueChangeView.backgroundColor = #colorLiteral(red: 0.92146945, green: 0.988289535, blue: 0.9449847937, alpha: 1)
            valueChangeLbl.text = String("+\(percentage)")
        } else {
            valueChangeLbl.textColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1)
            valueChangeView.backgroundColor = #colorLiteral(red: 0.9920850396, green: 0.933385551, blue: 0.9293023944, alpha: 1)
            valueChangeLbl.text = percentage
        }
    }
}
