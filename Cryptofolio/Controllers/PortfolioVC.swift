//
//  ViewController.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class PortfolioVC: UIViewController {
	@IBOutlet var tableView: UITableView!
	@IBOutlet var totalValueLbl: UILabel!
	@IBOutlet var totalChangeLbl: UILabel!
	@IBOutlet var chartView: ChartView!
	@IBOutlet var cardView: CardView!
	@IBOutlet var addBtn: UIButton!
	@IBOutlet var addLbl: UILabel!
	@IBOutlet var historyBtn: UIButton!
	@IBOutlet var historyLbl: UILabel!

	var viewModel: PortfolioViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}

	func setupView() {
		cardView.setupCard(in: self)
		viewModel.updatedCrypto = { [weak self] error in
			guard error == nil else {
				self?.presentErrorAlert(for: error!)
				return
			}
			self?.injectCryptoListViewModel()
            self?.viewModel.setupChart(in: self!.chartView)
			self?.setupLabels()
			self?.tableView.reloadData()
		}
	}

	func setupLabels() {
		enableAdd()
		enableHistory()
		totalValueLbl.text = viewModel.getTotalValue()
		let totalChange = viewModel.getTotalChange()
		if totalChange.first == "-" {
			totalChangeLbl.textColor = #colorLiteral(red: 0.9019744992, green: 0.3294329345, blue: 0.368601799, alpha: 1)
			totalChangeLbl.text = totalChange
		} else {
			totalChangeLbl.textColor = #colorLiteral(red: 0.2078431373, green: 0.8745098039, blue: 0.4352941176, alpha: 1)
			totalChangeLbl.text = "+\(totalChange)"
		}
	}

	func enableAdd() {
		if #available(iOS 13.0, *) {
			addLbl.textColor = .label
		} else {
			addLbl.textColor = .black
		}
		addBtn.isEnabled = true
	}

	func enableHistory() {
		if viewModel.getRowCount() > 0 {
			if #available(iOS 13.0, *) {
				historyLbl.textColor = .label
			} else {
				historyLbl.textColor = .black
			}
			historyBtn.isEnabled = true
		} else {
			if #available(iOS 13.0, *) {
				historyLbl.textColor = .secondaryLabel
			} else {
				historyLbl.textColor = .lightGray
			}
			historyBtn.isEnabled = false
		}
	}

	@IBAction func addPressed(_ sender: Any) {
		performSegue(withIdentifier: "addCoin", sender: self)
	}

	@IBAction func historyPressed(_ sender: Any) {
		performSegue(withIdentifier: "history", sender: self)
	}

	@IBAction func detailsPressed(_ sender: Any) {}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "addCoin":
            if let viewController = segue.destination as? AddCoinVC {
                viewController.viewModel = viewModel.createAddCoinVM()
                viewController.coinAdded = { [weak self] in
                    self?.viewModel.getMyCrypto()
                }
            }
        case "history":
            if let viewController = segue.destination as? HistoryVC {
                viewController.viewModel = viewModel.createHistoryVM()
            }
        case "info":
            if let viewController = segue.destination as? CoinInfoVC {
                guard let index = tableView.indexPathForSelectedRow else { return }
                viewController.viewModel = viewModel.createCoinInfoViewModel(for: index.row)
                viewController.coinChanged = { [weak self] change in
                    switch change {
                    case _ where change.amount != nil:
                        self?.changeAmount(change.amount!, at: index)
                    case _ where change.delete == true:
                        self?.deleteCoinRow(at: index)
                    case _ where change.add == true:
                        break
                    default:
                        return
                    }
                }
            }
        default:
            break
        }
	}

	func injectCryptoListViewModel() {
		let navController = tabBarController?.viewControllers![1] as! UINavigationController
		let vc = navController.topViewController as! CryptoListVC
		vc.viewModel = viewModel.createCryptoListViewModel()
	}
}

extension PortfolioVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if let headerView = view as? UITableViewHeaderFooterView {
			customHeaderView(for: headerView)
		}
	}

	func customHeaderView(for headerView: UITableViewHeaderFooterView) {
		if #available(iOS 13.0, *) {
			headerView.contentView.backgroundColor = .secondarySystemGroupedBackground
			headerView.backgroundView?.backgroundColor = .secondarySystemGroupedBackground
			headerView.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
			headerView.textLabel?.textColor = .label
		} else {
			headerView.contentView.backgroundColor = .white
			headerView.backgroundView?.backgroundColor = .white
			headerView.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
			headerView.textLabel?.textColor = .black
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "My Coins"
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getRowCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PortfolioCell
		let coin = viewModel.getCoin(at: indexPath.row)
		cell.setupCell(with: coin)
		return cell
	}

	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { _, indexPath in
			let alert = UIAlertController(title: "", message: "Edit coin amount", preferredStyle: .alert)
			alert.addTextField(configurationHandler: { textField in
				textField.placeholder = "New amount"
				textField.keyboardType = .decimalPad
			})
			alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
				guard let text = alert.textFields?.first?.text else { return }
                guard let newAmount = Double(text) else { return }
                if newAmount > 0 {
                    self.changeAmount(newAmount, at: indexPath)
                }
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(alert, animated: true)
		})

		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { _, indexPath in
            self.deleteCoinRow(at: indexPath)
		})
		return [deleteAction, editAction]
	}
    
    func changeAmount(_ amount: Double, at index: IndexPath) {
        self.viewModel.editCoin(amount: amount, at: index.row)
        self.setupLabels()
        self.tableView.reloadRows(at: [index], with: .fade)
    }
    
    func deleteCoinRow(at index: IndexPath) {
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [index], with: .automatic)
        self.viewModel.removeCoin(at: index.row)
        self.setupLabels()
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "info", sender: self)
    }

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y > 10, cardView.cardExpanded == false {
			cardView.expandCard()
		}
	}
}
