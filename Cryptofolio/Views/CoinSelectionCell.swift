//
//  CoinSelectionCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 27/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinSelectionCell: UITableViewCell {

    @IBOutlet var coinImage: UIImageView!
    @IBOutlet var coinSymbol: UILabel!
    @IBOutlet var coinName: UILabel!
    
    func setupCell(with info: CoinInfo) {
        let image = UIImage(data: CryptoImage.getData(for: info.id))
        coinImage.image = image
        coinSymbol.text = info.symbol
        coinName.text = info.name
    }
}
