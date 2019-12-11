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
    @IBOutlet var valueChangeLbl: UILabel!
    
    
    func setupCell(with info: CoinInfo) {
        if let imageData = info.imageData {
            cryptoImage.image = UIImage(data: imageData)
        }
        nameLbl.text = info.name
        fullPriceLbl.text = String(info.price)
        setValueLbl(with: 2.0)
    }
    
    private func setValueLbl(with value: Double) {
        if value > 0 {
            valueChangeLbl.textColor = #colorLiteral(red: 0, green: 0.6196078431, blue: 0.4509803922, alpha: 1)
            valueChangeLbl.text = String("+\(value)%")
        } else {
            valueChangeLbl.textColor = #colorLiteral(red: 0, green: 0.6196078431, blue: 0.4509803922, alpha: 1)
            valueChangeLbl.text = String("-\(value)%")
        }
    }
}
