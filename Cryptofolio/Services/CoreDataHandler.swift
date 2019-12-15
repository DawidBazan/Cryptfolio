//
//  CoreDataHandler.swift
//  Cryptofolio
//
//  Created by BZN8 on 27/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit
import Foundation
import CoreData

enum CoreDataHandler {
    static func addCoin(_ coin: CoinInfo, amount: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        if let myCrypto = fetchMyCrypto(in: context) {
            let myCoin = MyCoin(context: context)
            myCoin.date = Date()
            myCoin.name = coin.name
            myCoin.symbol = coin.symbol
            myCoin.amount = Double(amount) ?? 0
            myCoin.buyPrice = coin.price
            myCrypto.addToMyCoins(myCoin)
            appDelegate.saveContext()
        } else {
            print("Save failed")
        }
    }
    
    private static func fetchMyCrypto(in context: NSManagedObjectContext) -> MyCrypto? {
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
    
    static func fetchCrypto() -> [MyCoin] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<MyCrypto>(entityName: "MyCrypto")
        do {
            let counter = try context.count(for: request)
            if counter == 1 {
                let myCrypto = try context.fetch(request).first
                let allCrypto = myCrypto?.myCoins?.allObjects as! [MyCoin]
                return allCrypto
            } else {
                return []
            }
        } catch {
            print("Fetch failed")
            return []
        }
    }
    
    static func addTotal(_ value: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, value > 0 else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        if let myCrypto = fetchMyCrypto(in: context) {
            if isTotalsChangeValid(value, in: myCrypto) {
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
    
    // checking if value has change by 2 or more
    private static func isTotalsChangeValid(_ newValue: Double, in data: MyCrypto) -> Bool {
        let allTotals = data.myTotals?.allObjects as! [MyTotal]
        let sortedTotals = allTotals.sorted(by: { $0.date! > $1.date! })
        guard let previousTotal = sortedTotals.first else { return true }
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
    
    //fetching and sorting totals
    static func fetchTotals() -> [Double] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<MyCrypto>(entityName: "MyCrypto")
        do {
            let counter = try context.count(for: request)
            if counter == 1 {
                let myCrypto = try context.fetch(request).first
                let allTotals = myCrypto?.myTotals?.allObjects as! [MyTotal]
                let sortedTotals = allTotals.sorted(by: { $0.date! > $1.date! })
                let totalValues = sortedTotals.map({$0.value})
                return totalValues
            } else {
                return []
            }
        } catch {
            print("Fetch failed")
            return []
        }
    }
    
    static func removeCoin(_ coin: CoinInfo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<MyCrypto>(entityName: "MyCrypto")
        do {
            let counter = try context.count(for: request)
            if counter == 1 {
                let myCrypto = try context.fetch(request)
                let myCoins = myCrypto[0].myCoins?.allObjects as! [MyCoin]
                if let selectedCoin = myCoins.first(where: {$0.symbol == coin.symbol}) {
                    myCrypto[0].removeFromMyCoins(selectedCoin)
                    appDelegate.saveContext()
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    static func removeLastTotal() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<MyCrypto>(entityName: "MyCrypto")
        do {
            let counter = try context.count(for: request)
            if counter == 1 {
                let myCrypto = try context.fetch(request)
                let myTotals = myCrypto[0].myTotals?.allObjects as! [MyTotal]
                if let lastTotal = myTotals.first {
                    myCrypto[0].removeFromMyTotals(lastTotal)
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
}
