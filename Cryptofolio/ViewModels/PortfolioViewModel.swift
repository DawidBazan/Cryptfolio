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
            self.getMyCryptoInfo(from: crypto)
        }.catch { error in
            print("\(error)")
        }
    }
    
    private func getMyCryptoInfo(from crypto: Crypto) {
        let cryptoData = CoreDataHandler.fetchCrypto()
        crypto.info.forEach { coin in
            guard cryptoData.contains(where: {$0.symbol == coin.symbol}) else { return }
            if !myCrypto.contains(where: {$0.id == coin.id}) {
                myCrypto.append(coin)
            }
            updatedCrypto?()
        }
    }
    
    func getRowCount() -> Int {
        return myCrypto.count
    }
    
    func getCoin(at index: Int) -> CoinInfo {
        return myCrypto[index]
    }
    
    func getAllCrypto() -> [CoinInfo] {
        return crypto
    }
    
    func removeCoin(at index: Int) {
        
    }
    
    func getTotalValue() -> String {
        var total = 0.0
        myCrypto.forEach { coin in
            total += coin.price
        }
        let stringTotal = "$\(total.rounded())"
        return stringTotal
    }
}
