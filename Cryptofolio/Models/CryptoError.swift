//
//  CryptoError.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

enum CryptoError: Error {
	case unreachable
	case requestFailed
	case decodeFailed
}
