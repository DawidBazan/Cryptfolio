//
//  CoinSelectionViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 12/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class CoinSelectionViewModel {
	private let crypto: [CoinInfo]
	var updateSelection: ((CoinInfo) -> Void)?

	init(crypto: [CoinInfo]) {
		self.crypto = crypto
	}

	func getRowCount() -> Int {
		return crypto.count
	}

	func getCoin(at index: Int) -> CoinInfo {
		return crypto[index]
	}

	func updateSelectedCoin(_ coin: CoinInfo) {
		updateSelection?(coin)
	}
}
