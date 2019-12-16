//
//  Extensions.swift
//  Cryptofolio
//
//  Created by BZN8 on 16/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromCrypto(_ name: String) {
        self.image = UIImage(named: name)
    }
}
