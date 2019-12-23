//
//  CoreDataHandler.swift
//  Cryptofolio
//
//  Created by BZN8 on 27/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import CoreData
import Foundation
import UIKit

enum CoreDataHandler {
	private static let appDelegate = UIApplication.shared.delegate as! AppDelegate

	private static func fetchMyCryptoData() -> MyCrypto? {
		let context = appDelegate.persistentContainer.viewContext
		let request = NSFetchRequest<MyCrypto>(entityName: "MyCrypto")
		do {
			let counter = try context.count(for: request)
			if counter == 1 {
				let myCrypto = try context.fetch(request)
				return myCrypto[0]
			} else {
				let myCrypto = MyCrypto(context: context)
				return myCrypto
			}
		} catch {
			print("Fetch failed")
			return nil
		}
	}

	private static func deleteAllCryptoData() {
		let context = appDelegate.persistentContainer.viewContext
		let request = NSFetchRequest<MyCrypto>(entityName: "MyCrypto")
		do {
			let counter = try context.count(for: request)
			if counter == 1 {
				let myCrypto = try context.fetch(request)
				context.delete(myCrypto[0])
			}
		} catch {
			print("delete failed")
		}
	}

	static func fetchMyCoins() -> [MyCoin] {
		guard let myCrypto = fetchMyCryptoData() else { return [] }
		let myCoins = myCrypto.myCoins?.allObjects as! [MyCoin]
		return myCoins
	}

	static func addCoin(_ coin: Cryptocurrency, amount: Double) {
		let context = appDelegate.persistentContainer.viewContext
		if let myCrypto = fetchMyCryptoData() {
			let myCoin = MyCoin(context: context)
			myCoin.date = Date()
			myCoin.name = coin.name
			myCoin.symbol = coin.symbol
			myCoin.amount = amount
			myCoin.buyPrice = coin.price
			myCrypto.addToMyCoins(myCoin)
			appDelegate.saveContext()
		} else {
			print("Save failed")
		}
	}

	static func addTotal(_ value: Double) {
		guard value > 0 else { return }
		let context = appDelegate.persistentContainer.viewContext
		if let myCrypto = fetchMyCryptoData() {
			if TotalValueIsValid(value, in: myCrypto) {
				let myTotal = MyTotal(context: context)
				myTotal.date = Date()
				myTotal.value = value
				myCrypto.addToMyTotals(myTotal)
				appDelegate.saveContext()
			}
		} else {
			print("Save failed")
		}
	}

	// fetching and sorting totals
	static func fetchTotals() -> [Double] {
		guard let myCrypto = fetchMyCryptoData() else { return [] }
		let allTotals = myCrypto.myTotals?.allObjects as! [MyTotal]
		let sortedTotals = allTotals.sorted(by: { $0.date! < $1.date! })
		let totalValues = sortedTotals.map { $0.value }
		return totalValues
	}

	static func editCoin(amount: Double, _ coin: Cryptocurrency) {
		guard let myCrypto = fetchMyCryptoData() else { return }
		let myCoins = myCrypto.myCoins?.allObjects as! [MyCoin]
		if let selectedCoin = myCoins.first(where: { $0.symbol == coin.symbol }) {
			selectedCoin.amount = amount
		}
		appDelegate.saveContext()
	}

	static func removeCoin(_ coin: Cryptocurrency) {
		guard let myCrypto = fetchMyCryptoData() else { return }
		let myCoins = myCrypto.myCoins?.allObjects as! [MyCoin]
		if let selectedCoin = myCoins.first(where: { $0.symbol == coin.symbol }) {
			if myCoins.count == 1 {
				deleteAllCryptoData()
			} else {
				myCrypto.removeFromMyCoins(selectedCoin)
			}
			appDelegate.saveContext()
		}
	}

	static func removeLastTotal() {
		guard let myCrypto = fetchMyCryptoData() else { return }
		let myTotals = myCrypto.myTotals?.allObjects as! [MyTotal]
		if let lastTotal = myTotals.first {
			myCrypto.removeFromMyTotals(lastTotal)
		}
	}

	// checking if value has change by 2 or more
	private static func TotalValueIsValid(_ newValue: Double, in data: MyCrypto) -> Bool {
		let allTotals = data.myTotals?.allObjects as! [MyTotal]
		let sortedTotals = allTotals.sorted(by: { $0.date! < $1.date! })
		guard let previousTotal = sortedTotals.last else { return true }
		let valueChange = previousTotal.value - newValue
		if valueChange > 2 || valueChange < -2 {
			if allTotals.count == 80 {
				removeLastTotal()
			}
			return true
		} else {
			return false
		}
	}
}
