//
//  CryptoListVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 04/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CryptoListVC: UIViewController {
	@IBOutlet var tableView: UITableView!

	var viewModel: CryptoListViewModel? {
		didSet {
			if tableView != nil {
				tableView.reloadData()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewSetup()
	}

	override func viewWillAppear(_ animated: Bool) {
		if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
	}

	func viewSetup() {
		createSearchBar()
	}

	func createSearchBar() {
		let search = UISearchController(searchResultsController: nil)
		search.searchBar.showsCancelButton = false
		search.searchResultsUpdater = self
		search.searchBar.delegate = self
		search.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "marketInfo":
			if let viewController = segue.destination as? CoinInfoVC {
				guard let index = tableView.indexPathForSelectedRow else { return }
				viewController.viewModel = viewModel?.createCoinInfoViewModel(for: index.row)
				viewController.coinChanged = { [weak self] change in
					switch change {
					case _ where change.add == true:
						guard let amount = change.amount else { return }
						self?.tableView.beginUpdates()
						self?.tableView.deleteRows(at: [index], with: .automatic)
						self?.viewModel?.addCoin(from: index.row, amount: amount)
						self?.tableView.endUpdates()
					default:
						break
					}
				}
			}
		default:
			break
		}
	}
}

// MARK: - TableView Delegates

extension CryptoListVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let viewModel = viewModel else { return 0 }
		if viewModel.isCryptoFiltered() {
			return viewModel.getFilteredRowCount()
		} else {
			return viewModel.getRowCount()
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CryptoCell

		guard let viewModel = viewModel else { return cell }
		if viewModel.isCryptoFiltered() {
			let filteredCoin = viewModel.getFilteredCoin(at: indexPath.row)
			cell.setupCell(with: filteredCoin)
		} else {
			let coin = viewModel.getCoin(at: indexPath.row)
			cell.setupCell(with: coin)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Constant.hapticFeedback(style: .light)
		performSegue(withIdentifier: "marketInfo", sender: self)
	}
}

// MARK: - SearchBar Delegates

extension CryptoListVC: UISearchBarDelegate, UISearchResultsUpdating {
	func filterContentForSearchText(_ searchText: String) {
		if searchText.count != 0 {
			viewModel?.filterCrypto(with: searchText)
			tableView.reloadData()
		}
	}

	func updateSearchResults(for searchController: UISearchController) {
		filterContentForSearchText(searchController.searchBar.text!)
	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = true
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = nil
		searchBar.showsCancelButton = false
		searchBar.endEditing(true)

		viewModel?.clearFilteredCrypto()
		tableView.reloadData()
	}
}
