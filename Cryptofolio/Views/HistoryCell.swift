//
//  HistoryCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
	@IBOutlet var cryptoImage: UIImageView!
	@IBOutlet var nameLbl: UILabel!
	@IBOutlet var amountLbl: UILabel!
	@IBOutlet var priceLbl: UILabel!
	@IBOutlet var buyDateLbl: UILabel!
	@IBOutlet var changeLbl: UILabel!
	@IBOutlet var changeView: UIView!

	func setupCell(with coin: Cryptocurrency, change: Double) {
        cryptoImage.image = UIImage(named: coin.name)
		nameLbl.text = coin.symbol.uppercased()
		amountLbl.text = "\(coin.amount)"
		priceLbl.text = UnitFormatter.currency(from: coin.buyPrice)
		buyDateLbl.text = UnitFormatter.date(from: coin.buyDate)
		setChangeLbl(with: change)
	}

	private func setChangeLbl(with value: Double) {
		changeView.layer.cornerRadius = changeView.frame.height / 2
		let percentage = UnitFormatter.percentage(from: value)
		if value > 0 {
			changeLbl.textColor = Constant.Colors.primaryGreen
			if traitCollection.userInterfaceStyle == .dark {
				changeView.backgroundColor = Constant.Colors.darkGreen
			} else {
				changeView.backgroundColor = Constant.Colors.lightGreen
			}
			changeLbl.text = String("+\(percentage)")
		} else if value == 0 {
			if traitCollection.userInterfaceStyle == .dark {
				changeLbl.textColor = UIColor.white
				changeView.backgroundColor = Constant.Colors.darkGray
			} else {
				changeLbl.textColor = UIColor.black
				changeView.backgroundColor = Constant.Colors.lightGray
			}
			changeLbl.text = percentage
		} else {
			changeLbl.textColor = Constant.Colors.primaryRed
			if traitCollection.userInterfaceStyle == .dark {
				changeView.backgroundColor = Constant.Colors.darkRed
			} else {
				changeView.backgroundColor = Constant.Colors.lightRed
			}
			changeLbl.text = percentage
		}
	}
}
