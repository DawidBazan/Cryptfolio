//
//  CryptoFetcher.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import PromiseKit

struct CryptoFetcher {
    let network: NetworkService
    
    func fetchCrypto() -> Promise<[CoinInfo]> {
        return Promise { seal in
            network.requestCrypto { result in
                switch result {
                case let .success(data):
                    if let crypto = self.decodeData(data) {
                        seal.fulfill(crypto)
                    } else {
                        seal.reject(CryptoError.decodeFailed)
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
    }
    
    private func decodeData(_ data: Data) -> [CoinInfo]? {
        do {
            let decodedCrypto = try JSONDecoder().decode([CoinInfo].self, from: data)
            return decodedCrypto
        } catch {
            print("\(CryptoError.decodeFailed): \(error)")
            return []
        }
    }
}
