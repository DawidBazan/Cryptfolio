//
//  CoinInfoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinInfoCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var infoLbl: UILabel!
    
    func setupCell(with value: String, for title: String) {
        titleLbl.text = title
        infoLbl.text = value
    }
}
