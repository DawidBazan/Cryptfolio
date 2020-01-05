//
//  HistoryViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class HistoryViewModel {
	var myCoins: [Cryptocurrency]

	init(crypto: [Cryptocurrency]) {
		myCoins = crypto
	}

	func getRowCount() -> Int {
		return myCoins.count
	}

	func getCoin(at index: Int) -> Cryptocurrency {
		return myCoins[index]
	}

	func getPriceChange(for coin: Cryptocurrency) -> Double {
		let buyPrice = coin.buyPrice
		let currentPrice = coin.price
		let change = (currentPrice - buyPrice) / buyPrice
		let percentage = change * 100
		return percentage
	}
}
