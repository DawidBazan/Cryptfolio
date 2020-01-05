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
	func imageFromCrypto(_ name: String) {
		image = UIImage(named: name)
	}
}

extension UIViewController {
	func presentErrorAlert(for error: Error) {
		var title = ""
		var message = ""
		switch error {
		case CryptoError.decodeFailed:
			title = "Decode Failed"
			message = "Please try again later"
		case CryptoError.requestFailed:
			title = "Data request failed"
			message = "Please try again later"
		case CryptoError.unreachable:
			title = "Network is unreachable"
			message = "Please make sure your phone is connected to the interent"
		default:
			break
		}
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
			if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}))
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}
