//
//  ReachabilityService.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import Alamofire

protocol ReachabilityService {
    typealias ReachabilityCompetion = (Swift.Result<Bool, CryptoError>) -> Void
    func isReachable(completion: @escaping ReachabilityCompetion)
}

struct Reachability: ReachabilityService {
    let reachabilityManager = NetworkReachabilityManager()
    
    func isReachable(completion: @escaping ReachabilityCompetion) {
        guard let reachabilityManager = reachabilityManager else { return }
        let isReachable = reachabilityManager.isReachable
        if isReachable {
            completion(.success(true))
        } else {
            completion(.failure(.unreachable))
        }
    }
}
