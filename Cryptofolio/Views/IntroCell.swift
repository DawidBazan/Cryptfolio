//
//  IntroCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 17/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class IntroCell: UITableViewCell {
	@IBOutlet var cryptoImage: UIImageView!
	@IBOutlet var nameLbl: UILabel!
	@IBOutlet var amountLbl: UILabel!

	func setupCell(with coin: Cryptocurrency) {
		cryptoImage.imageFromCrypto(coin.name)
		nameLbl.text = coin.name
		if coin.amount > 0 {
			amountLbl.text = "\(coin.amount)"
        } else {
            amountLbl.text = ""
        }
	}
}
