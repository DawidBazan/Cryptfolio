//
//  CoinSelectionCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 27/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinSelectionCell: UITableViewCell {
	@IBOutlet var coinImageView: UIImageView!
	@IBOutlet var symbolLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!

    func setupCell(with name: String, symbol: String) {
		coinImageView.image = UIImage(named: name)
		symbolLabel.text = symbol.uppercased()
		nameLabel.text = name
	}
}
