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
		cryptoImage.imageFromCrypto(coin.name)
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
			changeLbl.textColor = #colorLiteral(red: 0.2078431373, green: 0.8745098039, blue: 0.4352941176, alpha: 1)
			if traitCollection.userInterfaceStyle == .dark {
				changeView.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
			} else {
				changeView.backgroundColor = #colorLiteral(red: 0.92146945, green: 0.988289535, blue: 0.9449847937, alpha: 1)
			}
			changeLbl.text = String("+\(percentage)")
		} else if value == 0 {
			if traitCollection.userInterfaceStyle == .dark {
				changeLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
				changeView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
			} else {
				changeLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
				changeView.backgroundColor = #colorLiteral(red: 0.9489305615, green: 0.9490671754, blue: 0.9693607688, alpha: 1)
			}
			changeLbl.text = percentage
		} else {
			changeLbl.textColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1)
			if traitCollection.userInterfaceStyle == .dark {
				changeView.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
			} else {
				changeView.backgroundColor = #colorLiteral(red: 0.9920850396, green: 0.933385551, blue: 0.9293023944, alpha: 1)
			}
			changeLbl.text = percentage
		}
	}
}
