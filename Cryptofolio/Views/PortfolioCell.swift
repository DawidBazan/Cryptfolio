//
//  CryptoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class PortfolioCell: UITableViewCell {

    @IBOutlet var cryptoImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var fullPriceLbl: UILabel!
    @IBOutlet var coinAmountLbl: UILabel!
    @IBOutlet var coinValueLbl: UILabel!
    
    func setupCell(with info: CoinInfo) {
        if let imageData = info.imageData {
            cryptoImage.image = UIImage(data: imageData)
        }
        nameLbl.text = info.name
        fullPriceLbl.text = UnitFormatter.currency(from: info.price)
        coinValueLbl.text = getCoinValue(info)
        coinAmountLbl.text = "\(info.amount)\(info.symbol)"
    }
    
    func getCoinValue(_ coin: CoinInfo) -> String {
        let amount = coin.amount
        let price = coin.price
        let value = amount * price
        return UnitFormatter.currency(from: value)
    }
}
