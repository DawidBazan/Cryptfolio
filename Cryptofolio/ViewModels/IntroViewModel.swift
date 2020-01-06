//
//  IntroViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 17/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import PromiseKit

class IntroViewModel {
	private let reachability: ReachabilityChecker
	private let cryptoFetcher: CryptoFetcher
	private var crypto: [Cryptocurrency] = []
	var updatedCrypto: (() -> Void)?

	init(reachability: ReachabilityChecker, cryptoFetcher: CryptoFetcher) {
		self.reachability = reachability
		self.cryptoFetcher = cryptoFetcher
		fetchCrypto()
	}

	private func fetchCrypto() {
		firstly {
			self.reachability.checkReachability()
		}.then { _ in
			self.cryptoFetcher.fetchCrypto()
		}.done { crypto in
			self.crypto = crypto
			self.updatedCrypto?()
		}.catch { error in
			print("\(error)")
		}
	}

	func addCoinAmount(_ amount: Double, at index: Int) {
		crypto[index].amount = amount
	}

	func addSelectedCoins(from indexes: [Int]) {
		indexes.forEach { index in
			let coin = crypto[index]
			CoreDataHandler.addCoin(coin, amount: coin.amount)
		}
	}

	// MARK: - Get functions

	func getRowCount() -> Int {
		return crypto.count
	}

	func getCoin(at index: Int) -> Cryptocurrency {
		return crypto[index]
	}
}
