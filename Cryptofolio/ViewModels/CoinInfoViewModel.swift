//
//  CoinInfoViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 23/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class CoinInfoViewModel {
    
    let coin: Cryptocurrency
    
    init(coin: Cryptocurrency) {
        self.coin = coin
    }
    
    func getPriceChanges() -> [Double] {
        return coin.sparklineIn7D.price
    }
    
    
}
