//
//  ReachabilityChecker.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import PromiseKit

struct ReachabilityChecker {
    let reachability: ReachabilityService
    
    func checkReachability() -> Promise<Bool> {
        return Promise { seal in
            reachability.isReachable { result in
                switch result {
                case let .success(isReachable):
                    seal.fulfill(isReachable)
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func updateWhenReachable(completion: @escaping (Bool) -> Void) {
        reachability.reachabilityObserver { result in
            switch result {
            case let .success(isReachable):
                completion(isReachable)
            case let .failure(error):
                print("\(error)")
            }
        }
    }
}
