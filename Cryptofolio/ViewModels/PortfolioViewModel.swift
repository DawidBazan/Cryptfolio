//
//  PortfolioViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 11/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import PromiseKit

class PortfolioViewModel {
	private let reachability: ReachabilityChecker
	private let cryptoFetcher: CryptoFetcher
	private var crypto: [CoinInfo] = []
	private var myCrypto: [CoinInfo] = []
	var updatedCrypto: ((Error?) -> Void)?

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
			self.getMyCrypto()
		}.catch { error in
			self.updatedCrypto?(error)
			self.observeReachability(when: error)
		}
	}

	private func observeReachability(when error: Error) {
		switch error {
		case CryptoError.unreachable:
			reachability.updateWhenReachable { isReachable in
				if isReachable {
					self.fetchCrypto()
				}
			}
		default:
			break
		}
	}

	func getMyCrypto() {
		let cryptoData = CoreDataHandler.fetchMyCoins()
		crypto.forEach { coin in
			guard let index = cryptoData.firstIndex(where: { $0.symbol == coin.symbol }) else { return }
			if !myCrypto.contains(where: { $0.id == coin.id }) {
				var myCoin = coin
				let amount = cryptoData[index].amount
				let buyPrice = cryptoData[index].buyPrice
				let buyDate = cryptoData[index].date
				myCoin.amount = amount
				myCoin.buyPrice = buyPrice
				myCoin.buyDate = buyDate
				myCrypto.append(myCoin)
			}
			updatedCrypto?(nil)
		}
	}

	func getRowCount() -> Int {
		return myCrypto.count
	}

	func getCoin(at index: Int) -> CoinInfo {
		return myCrypto[index]
	}

	func editCoin(amount: Double, at index: Int) {
		CoreDataHandler.editCoin(amount: amount, myCrypto[index])
		myCrypto[index].amount = amount
	}

	func removeCoin(at index: Int) {
		CoreDataHandler.removeCoin(myCrypto[index])
		myCrypto.remove(at: index)
	}

	func getTotalValue() -> String {
		let total = getCurrentTotal()
		CoreDataHandler.addTotal(total)
		return UnitFormatter.currency(from: total)
	}

	private func getCurrentTotal() -> Double {
		var total = 0.0
		myCrypto.forEach { coin in
			total += getCoinValue(coin)
		}
		return total
	}

	func getTotalChange() -> String {
		let myTotals = CoreDataHandler.fetchTotals()
		guard let oldTotal = myTotals.first else {
			let formattedChange = UnitFormatter.currency(from: 0)
			let formattedPrecentage = UnitFormatter.percentage(from: 0)
			return "\(formattedChange) (\(formattedPrecentage))"
		}
		let newTotal = getCurrentTotal()
		let change = newTotal - oldTotal
		let percentage = (change / oldTotal) * 100
		let formattedChange = UnitFormatter.currency(from: change)
		let formattedPrecentage = UnitFormatter.percentage(from: percentage)
		return "\(formattedChange) (\(formattedPrecentage))"
	}

	func getCoinValue(_ coin: CoinInfo) -> Double {
		let amount = coin.amount
		let price = coin.price
		let value = amount * price
		return value
	}

	func setupChart(in view: ChartView) {
		let myTotals = CoreDataHandler.fetchTotals()
		if myTotals.count > 9 {
			view.setupChart(with: myTotals)
		} else {
			view.setupChart(with: [])
		}
	}

	func createCryptoListViewModel() -> CryptoListViewModel {
		let viewModel = CryptoListViewModel(crypto: crypto)
		return viewModel
	}

	func createAddCoinVM() -> AddCoinViewModel {
		var availableCrypto: [CoinInfo] = [] // only coins that are not in myCrypto
		crypto.forEach { coin in
			if !myCrypto.contains(where: { $0.id == coin.id }) {
				availableCrypto.append(coin)
			}
		}
		let viewModel = AddCoinViewModel(crypto: availableCrypto)
		return viewModel
	}

	func createHistoryVM() -> HistoryViewModel {
		let viewModel = HistoryViewModel(crypto: myCrypto)
		return viewModel
	}
}