//
//  NetworkService.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Alamofire
import Foundation

protocol NetworkService {
	typealias CryptoResult = (Swift.Result<Data, CryptoError>) -> Void
	func requestCrypto(completion: @escaping CryptoResult)
}

struct Network: NetworkService {
	func requestCrypto(completion: @escaping Self.CryptoResult) {
		Alamofire.request(CryptoRouter.get).validate().responseJSON { response in
			switch response.result {
			case .success:
				guard let data = response.data else { return }
				completion(.success(data))
			case .failure:
				completion(.failure(.requestFailed))
			}
		}
	}
}
