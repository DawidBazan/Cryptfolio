//
//  CryptoViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import PromiseKit

class CryptoListViewModel {
	private var crypto: [CoinInfo] = []
	private var filteredCrypto: [CoinInfo] = []

	init(crypto: [CoinInfo]) {
		self.crypto = crypto
	}

	func getRowCount() -> Int {
		return crypto.count
	}

	func getFilteredRowCount() -> Int {
		return filteredCrypto.count
	}

	func getCoin(at index: Int) -> CoinInfo {
		return crypto[index]
	}

	func getFilteredCoin(at index: Int) -> CoinInfo {
		return filteredCrypto[index]
	}

	func filterCrypto(with searchText: String) {
		let filtered = crypto.filter { $0.name.lowercased().contains(searchText.lowercased()) }
		filteredCrypto = filtered
	}

	func clearFilteredCrypto() {
		filteredCrypto.removeAll()
	}

	func isCryptoFiltered() -> Bool {
		if filteredCrypto.isEmpty {
			return false
		} else {
			return true
		}
	}
}
