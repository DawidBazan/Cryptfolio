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
    
    init(reachability: ReachabilityChecker, cryptoFetcher: CryptoFetcher) {
        self.reachability = reachability
        self.cryptoFetcher = cryptoFetcher
        fetchCrypto()
    }
    
    func fetchCrypto() {
        firstly {
            self.reachability.checkReachability()
        }.then { _ in
            self.cryptoFetcher.fetchCrypto()
        }.done { crypto in
            print(crypto)
        }.catch { error in
            print("\(error)")
        }
    }
}
