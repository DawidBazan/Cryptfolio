//
//  Model.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

// MARK: - Crypto
struct Crypto: Codable {
    private let data: [Datum]
    let info: [CoinInfo]
    
    enum CodingKeys: String, CodingKey {
        case data, info
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        data = try container.decode([Datum].self, forKey: .data)
        info = sortCryptoData(data)
    }

}

// MARK: - Datum
private struct Datum: Codable {
    let id: Int
    let name, symbol: String
    let maxSupply: Int?
    let circulatingSupply, totalSupply: Double
    let cmcRank: Int
    let lastUpdated: String
    let quote: Quote

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case cmcRank = "cmc_rank"
        case lastUpdated = "last_updated"
        case quote
    }
}

// MARK: - Quote
private struct Quote: Codable {
    let usd: Usd

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - Usd
private struct Usd: Codable {
    let price, volume24H, percentChange1H, percentChange24H: Double
    let percentChange7D, marketCap: Double
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case marketCap = "market_cap"
        case lastUpdated = "last_updated"
    }
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

// MARK: - Custom Codable

struct CoinInfo: Codable {
    let id: Int
    let name, symbol: String
    let price: Double
    var holding: String
    var imageData: Data?
}

private func sortCryptoData(_ cryptoData: [Datum]) -> [CoinInfo] {
    var cryptoInfo: [CoinInfo] = []
    
    cryptoData.forEach { data in
        let info = CoinInfo(id: data.id,
                              name: data.name,
                              symbol: data.symbol,
                              price: data.quote.usd.price,
                              holding: "",
                              imageData: CryptoImage.getData(for: data.id))
        cryptoInfo.append(info)
    }
    return cryptoInfo
}
