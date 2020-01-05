//
//  RoundedButton.swift
//  Cryptofolio
//
//  Created by BZN8 on 04/01/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import Foundation

import Foundation
import UIKit

@IBDesignable class CustomButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
 
    func updateCornerRadius() {
        layer.cornerRadius = self.frame.height / 2
        layer.borderWidth = 0.8
        
        self.setTitleColor(.white, for: .normal)
        
        switch self.title(for: .normal) {
        case "Add":
            layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.8745098039, blue: 0.4352941176, alpha: 1).cgColor
        case "Delete":
            layer.borderColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1).cgColor
            self.backgroundColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1)
        default:
            layer.borderColor = UIColor.white.cgColor
        }
    }
}
