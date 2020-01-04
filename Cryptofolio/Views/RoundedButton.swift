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
        if self.title(for: .normal) == "Delete" {
            layer.borderColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1).cgColor
            self.backgroundColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1)
        } else {
            layer.borderColor = UIColor.white.cgColor
        }
    }
}
