//
//  ReachabilityService.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Alamofire
import Foundation

protocol ReachabilityService {
	typealias ReachabilityCompetion = (Swift.Result<Bool, CryptoError>) -> Void
	func isReachable(completion: @escaping ReachabilityCompetion)
	func reachabilityObserver(completion: @escaping ReachabilityCompetion)
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

	func reachabilityObserver(completion: @escaping Self.ReachabilityCompetion) { // used when network is unreachable
		guard let reachabilityManager = reachabilityManager else { return }
		reachabilityManager.startListening()
		reachabilityManager.listener = { _ in
			if reachabilityManager.isReachable {
				reachabilityManager.stopListening()
				completion(.success(true))
			} else {
				completion(.failure(.unreachable))
			}
		}
	}
}
