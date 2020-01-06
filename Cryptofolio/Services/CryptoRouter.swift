//
//  Router.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Alamofire
import Foundation

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
				return ["vs_currency": "usd",
				        "order": "market_cap_desc",
				        "ids": Constant.coinIds,
				        "sparkline": "true"]
			}
		}()

		let url = Constant.url
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method.rawValue

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
