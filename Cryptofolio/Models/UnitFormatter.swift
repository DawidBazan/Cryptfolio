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
    
    static func number(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
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

	static func date(from date: Date?) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy"
		guard let date = date else { return "" }
		return dateFormatter.string(from: date)
	}
}
