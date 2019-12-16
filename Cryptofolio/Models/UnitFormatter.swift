//
//  Formatter.swift
//  Cryptofolio
//
//  Created by BZN8 on 14/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

enum UnitFormatter {
    
    static func percentage(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1
        let finalValue = formatter.string(from: value as NSNumber)!
        return finalValue
    }
    
    static func currency(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let us = Locale(identifier: "en_US")
        formatter.locale = us
        let finalValue = formatter.string(from: value as NSNumber)!
        return finalValue
    }
}
