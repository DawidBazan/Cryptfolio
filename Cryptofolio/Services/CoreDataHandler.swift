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
}
