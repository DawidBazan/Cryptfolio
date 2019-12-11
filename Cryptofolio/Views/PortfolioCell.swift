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
        fullPriceLbl.text = String(info.price)
        coinValueLbl.text = "£1104.34"
        coinAmountLbl.text = "0.235\(info.symbol)"
    }
}
