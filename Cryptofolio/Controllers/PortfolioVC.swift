//
//  ViewController.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class PortfolioVC: UIViewController {
	var viewModel: PortfolioViewModel!
    let contentView = PortfolioView()

    override func loadView() {
        view = contentView
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
        addBottomSheetView()
	}

	func setupView() {
//        currencyBtn.title = FiatCurrency.usd.rawValue
//        contentView.bottomSheet.tableView.register(PortfolioCell.self, forCellReuseIdentifier: "cell")
//        contentView.bottomSheet.tableView.delegate = self
//        contentView.bottomSheet.tableView.dataSource = self
        viewModel.fetchCrypto(in: .usd)
		viewModel.updatedCrypto = { [weak self] error in
			guard error == nil else {
				self?.presentErrorAlert(for: error!)
				return
			}
			self?.injectCryptoListViewModel() // inject due to crypto array change after update
//			self?.viewModel.setupChart(in: self!.chartView)
            self?.contentView.totalLabel.text = self?.viewModel.getTotalValue()
            self?.contentView.totalChangeLabel.text = self?.viewModel.getTotalChange()
//			self?.contentView.bottomSheet.tableView.reloadData()
		}
	}
    
    @IBAction func currencyChangePressed(_ sender: UIBarButtonItem) {
        switch sender.title {
        case FiatCurrency.usd.rawValue:
            sender.title = FiatCurrency.eur.rawValue
            viewModel.fetchCrypto(in: .eur)
        case FiatCurrency.eur.rawValue:
            sender.title = FiatCurrency.gbp.rawValue
            viewModel.fetchCrypto(in: .gbp)
        case FiatCurrency.gbp.rawValue:
            sender.title = FiatCurrency.usd.rawValue
            viewModel.fetchCrypto(in: .usd)
        default:
            break
        }
        UserDefaults.standard.set(sender.title, forKey: "Currency")
    }
    
	@IBAction func addPressed(_ sender: Any) {
		Constant.hapticFeedback(style: .medium)
		performSegue(withIdentifier: "addCoin", sender: self)
	}

	@IBAction func historyPressed(_ sender: Any) {
		Constant.hapticFeedback(style: .medium)
		performSegue(withIdentifier: "history", sender: self)
	}

	@IBAction func detailsPressed(_ sender: Any) {} // currently unused and hidden

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "addCoin":
			if let viewController = segue.destination as? AddCoinVC {
				viewModel.segueToAddCoinVC(viewController)
			}
		case "history":
			if let viewController = segue.destination as? HistoryVC {
				viewModel.segueToHistoryVC(viewController)
			}
		case "info":
			if let viewController = segue.destination as? CoinInfoVC {
//                guard let index = contentView.bottomSheet.tableView.indexPathForSelectedRow else { return }
//				viewModel.segueToCoinInfoVC(viewController, coinIndex: index.row)
			}
		default:
			break
		}
	}

	func injectCryptoListViewModel() {
		let navController = tabBarController?.viewControllers![1] as! UINavigationController
		guard let vc = navController.topViewController as? CryptoListVC else { return }
		vc.viewModel = viewModel.createCryptoListViewModel()
	}
    
    func addBottomSheetView() {
        let bottomSheetVC = BottomSheetViewController()
        self.addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
    }
}

// MARK: - TableView Delegates

//extension PortfolioVC: UITableViewDelegate, UITableViewDataSource {
//	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//		if let headerView = view as? UITableViewHeaderFooterView {
//			customHeaderView(for: headerView)
//		}
//	}
//
//	func customHeaderView(for headerView: UITableViewHeaderFooterView) {
//		if #available(iOS 13.0, *) {
//			headerView.contentView.backgroundColor = .secondarySystemGroupedBackground
//			headerView.backgroundView?.backgroundColor = .secondarySystemGroupedBackground
//			headerView.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//			headerView.textLabel?.textColor = .label
//		} else {
//			headerView.contentView.backgroundColor = .white
//			headerView.backgroundView?.backgroundColor = .white
//			headerView.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//			headerView.textLabel?.textColor = .black
//		}
//	}
//
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return "My Coins"
//	}
//
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return viewModel.getRowCount()
//	}
//
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PortfolioCell
//        let coin = viewModel.getCoin(at: indexPath.row).asPresentable
//        cell.setupCell(with: coin.name,
//                       price: coin.unitPrice,
//                       amount: coin.amount,
//                       value: coin.totalValue)
//		return cell
//	}
//
//	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//		let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { _, indexPath in
//			self.presentEditAlert { newAmount in
////				self.changeAmount(newAmount, at: indexPath)
//			}
//		})
//
//		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { _, indexPath in
//			self.presentDeleteAlert { [weak self] in
////				self?.deleteCoinRow(at: indexPath)
//				self?.injectCryptoListViewModel() // inject due to crypto array change
//			}
//		})
//		return [deleteAction, editAction]
//	}
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		Constant.hapticFeedback(style: .light)
//		performSegue(withIdentifier: "info", sender: self)
//	}

//	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//		if scrollView.contentOffset.y > 10, cardView.cardExpanded == false {
//			cardView.expandCard()
//		}
//	}
//
//	func changeAmount(_ amount: Double, at index: IndexPath) {
//		viewModel.editCoin(amount: amount, at: index.row)
//		setupLabels()
//		tableView.reloadRows(at: [index], with: .fade)
//	}
//
//	func deleteCoinRow(at index: IndexPath) {
//		tableView.beginUpdates()
//		tableView.deleteRows(at: [index], with: .automatic)
//		viewModel.removeCoin(at: index.row)
//		setupLabels()
//		tableView.endUpdates()
//	}
//}
