//
//  CoinInfoViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 23/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class CoinInfoViewModel {
    
    private let coin: Cryptocurrency
    private var isInPortfolio: Bool
    private var coinInfo: [String] = []
    private var coinTitles = ["Rank:", "Price:", "Market Cap:", "Volume:", "Circulating Supply:", "24H Change:"]
    
    init(coin: Cryptocurrency, isInPortfolio: Bool = false) {
        self.coin = coin
        self.isInPortfolio = isInPortfolio
        retrieveCoinInfo()
    }
    
    private func retrieveCoinInfo() {
        let coinRank = "\(coin.marketCapRank)"
        let currentPrice = UnitFormatter.currency(from: coin.price)
        let marketCap = UnitFormatter.currency(from: Double(coin.marketCap))
        let volume = UnitFormatter.currency(from: Double(coin.totalVolume))
        let circulatingSupply = UnitFormatter.number(from: coin.circulatingSupply)
        let changePercentage = UnitFormatter.percentage(from: coin.priceChangePercentage24H)
        coinInfo = [coinRank, currentPrice, marketCap, volume, circulatingSupply, changePercentage]
    }
    
    func getPriceHistory() -> [Double] {
        return coin.sparklineIn7D.price
    }
    
    func getPriceForIndex(_ index: Int) -> String {
        let price = coin.sparklineIn7D.price[index]
        let formattedPrice = UnitFormatter.currency(from: price)
        return formattedPrice
    }
    
    func getRowCount() -> Int {
        return coinInfo.count
    }
    
    func getTitle(for index: Int) -> String {
        return coinTitles[index]
    }
    
    func getCoinInfo(at index: Int) -> String {
        return coinInfo[index]
    }
    
    func getCoinPrice() -> String {
        return UnitFormatter.currency(from: coin.price)
    }
    
    func getCoinPriceChange() -> String {
        return UnitFormatter.percentage(from: coin.priceChangePercentage24H)
    }
    
    func isCoinInPortfolio() -> Bool {
        return isInPortfolio
    }
    
    func addCoin(with amount: Double) -> CoinChange {
        return CoinChange(amount: amount, add: true)
    }
    
    func changeCoinAmount(_ amount: Double) -> CoinChange {
        return CoinChange(amount: amount)
    }
    
    func deleteCoin() -> CoinChange {
        return CoinChange(delete: true)
    }
}
