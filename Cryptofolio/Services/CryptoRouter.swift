//
//  Router.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import Alamofire

enum CryptoRouter: URLRequestConvertible {
    case get
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .get:
                return ["limit": 5]
            }
        }()
        
        let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue(Constants.apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")

        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: params)
    }
}
