//
//  CoinInfoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinInfoCell: UITableViewCell {
	@IBOutlet var titleLebel: UILabel!
	@IBOutlet var infoLebel: UILabel!

	func setupCell(with value: String, for title: String) {
		titleLebel.text = title
		infoLebel.text = value
	}
}
