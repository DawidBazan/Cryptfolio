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

	func setupCell(with info: Cryptocurrency) {
		cryptoImage.imageFromCrypto(info.name)
		nameLbl.text = info.symbol.uppercased()
		fullPriceLbl.text = UnitFormatter.currency(from: info.price) // change to 2 decimal places
		setValueLbl(with: info.priceChangePercentage24H)
	}

	private func setValueLbl(with value: Double) {
		valueChangeView.layer.cornerRadius = valueChangeView.frame.height / 2
		let percentage = UnitFormatter.percentage(from: value)
		if value > 0 {
			valueChangeLbl.textColor = Constant.Colors.primaryGreen
			if traitCollection.userInterfaceStyle == .dark {
				valueChangeView.backgroundColor = Constant.Colors.darkGreen
			} else {
				valueChangeView.backgroundColor = Constant.Colors.lightGreen
			}

			valueChangeLbl.text = String("+\(percentage)")
		} else {
			valueChangeLbl.textColor = Constant.Colors.primaryRed
			if traitCollection.userInterfaceStyle == .dark {
				valueChangeView.backgroundColor = Constant.Colors.darkRed
			} else {
				valueChangeView.backgroundColor = Constant.Colors.lightRed
			}
			valueChangeLbl.text = percentage
		}
	}
}
