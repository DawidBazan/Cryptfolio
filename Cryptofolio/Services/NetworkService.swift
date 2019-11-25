//
//  NetworkService.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import Alamofire

struct ImageResult {
    let id: Int
    let data: Data
}

protocol NetworkService {
    typealias CryptoResult = (Swift.Result<Data, CryptoError>) -> Void
    typealias CryptoImageResult = (Swift.Result<ImageResult, CryptoError>) -> Void
    func requestCrypto(completion: @escaping CryptoResult)
    func requestCryptoImage(for id: Int, completion: @escaping CryptoImageResult)
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
    
    func requestCryptoImage(for id: Int, completion: @escaping Self.CryptoImageResult) {
        Alamofire.request("\(Constants.imageURL)\(id).png", method: .get).response { response in
            guard let data = response.data else {
                completion(.failure(.requestFailed))
                return
            }
            let result = ImageResult(id: id, data: data)
            completion(.success(result))
        }
    }
}
