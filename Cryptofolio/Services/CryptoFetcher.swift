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
    
    func fetchCrypto() -> Promise<Crypto> {
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
    
    private func decodeData(_ data: Data) -> Crypto? {
        guard let decodedCrypto = try? JSONDecoder().decode(Crypto.self, from: data) else {
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(json!)
            return nil
        }
        return decodedCrypto
    }
}
