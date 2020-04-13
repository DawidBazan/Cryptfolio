//
//  PresentableCryptoModel.swift
//  Cryptofolio
//
//  Created by Dawid on 09/04/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import Foundation

struct PresentableCrypto {
    let name: String
    let symbol: String
    let unitPrice: String
    let amount: String
    let totalValue: String
    let didPirceDrop: Bool
    let changePercentage: String
}

extension Cryptocurrency {
    var asPresentable: PresentableCrypto {
        let this = PresentableCrypto(
            name: name,
            symbol: symbol.uppercased(),
            unitPrice: UnitFormatter.currency(from: price),
            amount: "\(amount)\(symbol.uppercased())",
            totalValue: getCoinTotalValue(),
            didPirceDrop: priceChangePercentage24H < 0,
            changePercentage: getChangePercentage())
        return this
    }
    
    private func getCoinTotalValue() -> String {
        let value = amount * price
        return UnitFormatter.currency(from: value)
    }
    
    private func getChangePercentage() -> String {
        let didPriceDrop = priceChangePercentage24H < 0
        let formattedPercentage = didPriceDrop ? UnitFormatter.percentage(from: priceChangePercentage24H): "+ \(UnitFormatter.percentage(from: priceChangePercentage24H))"
        return formattedPercentage
    }
}
