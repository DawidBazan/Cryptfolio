//
//  HistoryViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class HistoryViewModel {
    
    var myCoins: [CoinInfo]
    
    init(crypto: [CoinInfo]) {
        self.myCoins = crypto
    }
    
    func getRowCount() -> Int {
        return myCoins.count
    }
    
    func getCoin(at index: Int) -> CoinInfo {
        return myCoins[index]
    }
    
    func getPriceChange(for coin: CoinInfo) -> Double {
        let buyPrice = coin.buyPrice
        let currentPrice = coin.price
        let change = (currentPrice - buyPrice) / buyPrice
        let percentage = change * 100
        return percentage
    }
}
