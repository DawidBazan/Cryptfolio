//
//  Model.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

// MARK: - Crypto

struct Cryptocurrency: Codable {
	let id, symbol, name: String
	//    let imageURL: String
	let price: Double
	let marketCap, marketCapRank, totalVolume: Int
	let high24H, low24H, priceChange24H, priceChangePercentage24H: Double
	let circulatingSupply: Double
	let sparklineIn7D: SparklineIn7D
	//    let totalSupply: Int
	var amount: Double = 0
	var buyPrice: Double = 0
	var buyDate: Date?

	enum CodingKeys: String, CodingKey {
		case id, symbol, name
		//        case imageURL = "image"
		case price = "current_price"
		case marketCap = "market_cap"
		case marketCapRank = "market_cap_rank"
		case totalVolume = "total_volume"
		case high24H = "high_24h"
		case low24H = "low_24h"
		case priceChange24H = "price_change_24h"
		case priceChangePercentage24H = "price_change_percentage_24h"
		case circulatingSupply = "circulating_supply"
		case sparklineIn7D = "sparkline_in_7d"
		//        case totalSupply = "total_supply"
	}
}

struct SparklineIn7D: Codable {
	let price: [Double]
}

// MARK: - Encode/decode helpers

private class JSONNull: Codable, Hashable {
	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public func hash(into hasher: inout Hasher) {
		// No-op
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}
