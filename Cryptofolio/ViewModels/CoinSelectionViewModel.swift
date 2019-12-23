//
//  CoinSelectionViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 12/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class CoinSelectionViewModel {
	private let crypto: [Cryptocurrency]
	var updateSelection: ((Cryptocurrency) -> Void)?

	init(crypto: [Cryptocurrency]) {
		self.crypto = crypto
	}

	func getRowCount() -> Int {
		return crypto.count
	}

	func getCoin(at index: Int) -> Cryptocurrency {
		return crypto[index]
	}

	func updateSelectedCoin(_ coin: Cryptocurrency) {
		updateSelection?(coin)
	}
}
