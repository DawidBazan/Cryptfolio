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
	private var crypto: [Cryptocurrency] = []
	private var myCrypto: [Cryptocurrency] = []
	var updatedCrypto: ((Error?) -> Void)?

	init(reachability: ReachabilityChecker, cryptoFetcher: CryptoFetcher) {
		self.reachability = reachability
		self.cryptoFetcher = cryptoFetcher
		NotificationCenter.default.addObserver(self, // used to update data when new coin is added from cryptoList
		                                       selector: #selector(newCoinAdded),
		                                       name: Notification.Name("NewCoinAdded"),
		                                       object: nil)
	}

	@objc private func newCoinAdded() {
		getMyCrypto()
	}

    func fetchCrypto(in currency: FiatCurrency) {
		firstly {
			self.reachability.checkReachability()
		}.then { _ in
            self.cryptoFetcher.fetchCrypto(in: currency)
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
                    self.fetchCrypto(in: .usd)
				}
			}
		default:
			break
		}
	}

	func setupChart(in view: ChartView) {
		let myTotals = get7dTotals()
		if !myTotals.isEmpty {
			view.setupChart(with: myTotals)
		} else {
			view.setupChart(with: [])
		}
	}

	func getMyCrypto() {
		let cryptoData = CoreDataHandler.fetchMyCoins()
        myCrypto.removeAll()
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
		}
		updatedCrypto?(nil)
	}

	// MARK: - Get functions

	func getRowCount() -> Int {
		return myCrypto.count
	}

	func getCoin(at index: Int) -> Cryptocurrency {
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
		return UnitFormatter.currency(from: total)
	}

	func getTotalChange() -> String {
		let myTotals = get7dTotals()
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

	private func getCurrentTotal() -> Double {
		var total = 0.0
		myCrypto.forEach { coin in
			total += getCoinValue(coin)
		}
		return total
	}

	private func get7dTotals() -> [Double] {
		var coinsTotals: [Double] = []

		for (index, coin) in myCrypto.enumerated() {
			if index > 0 {
				for (index, total) in coin.sparklineIn7D.price.enumerated() {
					let totalAmount = total * coin.amount
					if coinsTotals.count > index {
						coinsTotals[index] = coinsTotals[index] + totalAmount
					}
				}
			} else {
				let totalAmounts = coin.sparklineIn7D.price.map { $0 * coin.amount }
				coinsTotals = totalAmounts
			}
		}
		return coinsTotals
	}

	func getCoinValue(_ coin: Cryptocurrency) -> Double {
		let amount = coin.amount
		let price = coin.price
		let value = amount * price
		return value
	}

	// MARK: - Segue functions

	func segueToAddCoinVC(_ viewController: AddCoinVC) {
		viewController.viewModel = createAddCoinVM()
		viewController.coinAdded = { [weak self] in
			self?.getMyCrypto()
		}
	}

	func segueToHistoryVC(_ viewController: HistoryVC) {
		viewController.viewModel = createHistoryVM()
	}

	func segueToCoinInfoVC(_ viewController: CoinInfoVC, coinIndex: Int) {
		viewController.viewModel = createCoinInfoViewModel(for: coinIndex)
		viewController.coinChanged = { [weak self] change in
			switch change {
			case _ where change.amount != nil:
				self?.editCoin(amount: change.amount!, at: coinIndex)
				self?.updatedCrypto?(nil)
			case _ where change.delete == true:
				self?.removeCoin(at: coinIndex)
				self?.updatedCrypto?(nil)
			default:
				return
			}
		}
	}

	// MARK: - ViewModel create functions

	func createCoinInfoViewModel(for index: Int) -> CoinInfoViewModel {
		let viewModel = CoinInfoViewModel(coin: myCrypto[index], isInPortfolio: true)
		return viewModel
	}

	func createCryptoListViewModel() -> CryptoListViewModel {
		var availableCrypto: [Cryptocurrency] = [] // only coins that are not in myCrypto
		crypto.forEach { coin in
			if !myCrypto.contains(where: { $0.id == coin.id }) {
				availableCrypto.append(coin)
			}
		}
		let viewModel = CryptoListViewModel(crypto: availableCrypto)
		return viewModel
	}

	func createAddCoinVM() -> AddCoinViewModel {
		var availableCrypto: [Cryptocurrency] = [] // only coins that are not in myCrypto
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
