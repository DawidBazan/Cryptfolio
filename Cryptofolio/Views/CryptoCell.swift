//
//  CryptoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CryptoCell: UITableViewCell {

    @IBOutlet var cryptoImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var fullPriceLbl: UILabel!
    @IBOutlet var coinAmountLbl: UILabel!
    @IBOutlet var coinValueLbl: UILabel!
    
    func setupCell(with cryptoInfo: CryptoInfo) {
        if let imageData = cryptoInfo.image {
            cryptoImage.image = UIImage(data: imageData)
        }
        nameLbl.text = cryptoInfo.name
        fullPriceLbl.text = String(cryptoInfo.price)
        coinValueLbl.text = "£1104.34"
        coinAmountLbl.text = "0.235\(cryptoInfo.symbol)"
    }
}
