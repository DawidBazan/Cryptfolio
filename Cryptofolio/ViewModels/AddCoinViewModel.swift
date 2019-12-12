//
//  AddCoinViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 12/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class AddCoinViewModel {
    
    private let crypto: [CoinInfo]
    private var selectedCoin: CoinInfo?
    
    init(crypto: [CoinInfo]) {
        self.crypto = crypto
    }
    
    func getRowCount() -> Int {
        return crypto.count
    }
    
    func getCountForActionSheet() -> Int { // to display a maximum of 3 options in the action sheet
        if crypto.count > 2 {
            return 3
        } else {
            return crypto.count
        }
    }
    
    func getCoin(at index: Int) -> CoinInfo {
        return crypto[index]
    }
    
    func getFirstCoin() -> CoinInfo? {
        return crypto.first
    }
    
    func getSelectedCoin() -> CoinInfo? {
        return selectedCoin
    }
    
    func setSelectedCoin(to coin: CoinInfo) {
        selectedCoin = coin
    }
}
