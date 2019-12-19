//
//  CryptoImage.swift
//  Cryptofolio
//
//  Created by BZN8 on 25/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import UIKit

enum CryptoImage {
	static func getData(for id: Int) -> Data {
		let data = UIImage(named: "\(id)")?.pngData() ?? Data()
		return data
	}
}
