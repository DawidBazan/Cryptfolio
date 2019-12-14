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
            self.crypto = crypto.info
            self.getMyCrypto()
        }.catch { error in
            print("\(error)")
        }
    }
    
    func getMyCrypto() {
        let cryptoData = CoreDataHandler.fetchCrypto()
        crypto.forEach { coin in
            guard let index = cryptoData.firstIndex(where: {$0.symbol == coin.symbol}) else { return }
            if !myCrypto.contains(where: {$0.id == coin.id}) {
                var myCoin = coin
                let amount = cryptoData[index].amount
                let buyPrice = cryptoData[index].buyPrice
                myCoin.amount = amount
                myCoin.buyPrice = buyPrice
                myCrypto.append(myCoin)
            }
            updatedCrypto?()
        }
    }
    
    func setupChart(in view: ChartView) {
        let myTotals = CoreDataHandler.fetchTotals()
        if myTotals.count > 9 {
            view.setupChart(with: myTotals)
        } else {
            view.setupChart(with: [])
        }
    }
    
    func getRowCount() -> Int {
        return myCrypto.count
    }
    
    func getCoin(at index: Int) -> CoinInfo {
        return myCrypto[index]
    }
    
    func removeCoin(at index: Int) {
        
    }
    
    func getTotalValue() -> String {
        var total = 0.0
        myCrypto.forEach { coin in
            total += getCoinValue(coin)
        }
        CoreDataHandler.addTotal(total)
        return UnitFormatter.currency(from: total)
    }
    
    func getCoinValue(_ coin: CoinInfo) -> Double {
        let amount = coin.amount
        let price = coin.price
        let value = amount * price
        return value
    }
    
    func createAddCoinVM() -> AddCoinViewModel {
        var availableCrypto: [CoinInfo] = [] //only coins that are not in myCrypto
        crypto.forEach { (coin) in
            if !myCrypto.contains(where: {$0.id == coin.id}) {
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
