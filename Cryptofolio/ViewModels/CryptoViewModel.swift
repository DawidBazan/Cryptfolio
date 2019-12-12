//
//  CryptoViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import PromiseKit

class CryptoViewModel {
    private let reachability: ReachabilityChecker
    private let cryptoFetcher: CryptoFetcher
    private var crypto: [CoinInfo] = []
    private var filteredCrypto: [CoinInfo] = []
    var updatedCrypto: (() -> Void)?
    
    init(reachability: ReachabilityChecker, cryptoFetcher: CryptoFetcher) {
        self.reachability = reachability
        self.cryptoFetcher = cryptoFetcher
    }
    
    func fetchCrypto() {
        firstly {
            self.reachability.checkReachability()
        }.then { _ in
            self.cryptoFetcher.fetchCrypto()
        }.done { crypto in
            self.crypto = crypto.info
            self.updatedCrypto?()
        }.catch { error in
            print("\(error)")
        }
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
        let filtered = crypto.filter({ $0.name.lowercased().contains(searchText.lowercased())})
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
