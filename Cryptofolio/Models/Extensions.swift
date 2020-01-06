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
		alert.view.tintColor = Constant.Colors.orange
		present(alert, animated: true, completion: nil)
	}

	func presentAddAlert(_ added: @escaping (Double) -> Void) {
		let alert = UIAlertController(title: "", message: "Enter coin amount", preferredStyle: .alert)
		alert.addTextField(configurationHandler: { textField in
			textField.placeholder = "amount eg. 10BTC"
			textField.keyboardType = .decimalPad
		})
		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
			guard let text = alert.textFields?.first?.text else { return }
			guard let amount = Double(text) else { return }
			if amount > 0 {
				Constant.hapticFeedback(style: .medium)
				added(amount)
			}
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.view.tintColor = Constant.Colors.orange
		present(alert, animated: true)
	}

	func presentEditAlert(_ edited: @escaping (Double) -> Void) {
		let alert = UIAlertController(title: "", message: "Edit coin amount", preferredStyle: .alert)
		alert.addTextField(configurationHandler: { textField in
			textField.placeholder = "New amount eg. 10BTC"
			textField.keyboardType = .decimalPad
		})
		alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
			guard let text = alert.textFields?.first?.text else { return }
			guard let newAmount = Double(text) else { return }
			if newAmount > 0 {
				Constant.hapticFeedback(style: .medium)
				edited(newAmount)
			}
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.view.tintColor = Constant.Colors.orange
		present(alert, animated: true)
	}

	func presentDeleteAlert(_ deleted: @escaping () -> Void) {
		let alert = UIAlertController(title: "", message: "Delete coin from portfolio?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
			Constant.hapticFeedback(style: .medium)
			deleted()
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.view.tintColor = Constant.Colors.orange
		present(alert, animated: true)
	}
}
