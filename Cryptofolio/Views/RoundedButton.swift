//
//  RoundedButton.swift
//  Cryptofolio
//
//  Created by BZN8 on 04/01/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomButton: UIButton {
	override func layoutSubviews() {
		super.layoutSubviews()
		updateCornerRadius()
	}

	func updateCornerRadius() {
		layer.cornerRadius = frame.height / 2
		layer.borderWidth = 0.8

		setTitleColor(.white, for: .normal)

		switch title(for: .normal) {
		case "Add":
			layer.borderColor = Constant.Colors.primaryGreen.cgColor
		case "Delete":
			layer.borderColor = Constant.Colors.primaryRed.cgColor
			backgroundColor = Constant.Colors.primaryRed
		default:
			layer.borderColor = UIColor.white.cgColor
		}
	}
}
