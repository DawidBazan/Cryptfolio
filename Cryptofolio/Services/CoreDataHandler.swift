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
    static func saveCrypto(_ crypto: CryptoInfo, amount: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        if let myCrypto = fetchMyCrypto(in: context) {
            let myCoin = MyCoin(context: context)
            myCoin.name = crypto.name
            myCoin.symbol = crypto.symbol
            myCoin.amount = amount
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
        }catch {
            print("Fetch failed")
            return nil
        }
    }
    
    static func removeCrypto() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext

    }
}
