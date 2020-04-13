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
	private var crypto: [Cryptocurrency] = []
	private var filteredCrypto: [Cryptocurrency] = []

	init(crypto: [Cryptocurrency]) {
		self.crypto = crypto
	}

	func filterCrypto(with searchText: String) {
		let filtered = crypto.filter { $0.name.lowercased().contains(searchText.lowercased()) }
		filteredCrypto = filtered
	}

	func clearFilteredCrypto() {
		filteredCrypto.removeAll()
	}

	func addCoin(from index: Int, amount: Double) {
		CoreDataHandler.addCoin(crypto[index], amount: amount)
		crypto.remove(at: index)
		NotificationCenter.default.post(name: Notification.Name("NewCoinAdded"), object: nil)
	}

	// MARK: - Get functions

	func getRowCount() -> Int {
		return crypto.count
	}

	func getFilteredRowCount() -> Int {
		return filteredCrypto.count
	}

	func getCoin(at index: Int) -> PresentableCrypto {
        return crypto[index].asPresentable
    }

	func getFilteredCoin(at index: Int) -> PresentableCrypto {
        return filteredCrypto[index].asPresentable
	}

	func isCryptoFiltered() -> Bool {
		if filteredCrypto.isEmpty {
			return false
		} else {
			return true
		}
	}

	// MARK: - ViewModel create function

	func createCoinInfoViewModel(for index: Int) -> CoinInfoViewModel {
		let viewModel = CoinInfoViewModel(coin: crypto[index])
		return viewModel
	}
}
