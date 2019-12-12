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
    
    var viewModel: CryptoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    func viewSetup() {
        createSearchBar()
        viewModel.updatedCrypto = {
            self.tableView.reloadData()
        }
        viewModel.fetchCrypto()
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
}

extension CryptoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isCryptoFiltered() {
            return viewModel.getFilteredRowCount()
        } else {
            return viewModel.getRowCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CryptoCell
        if viewModel.isCryptoFiltered() {
            let filteredCoin = viewModel.getFilteredCoin(at: indexPath.row)
            cell.setupCell(with: filteredCoin)
        } else {
            let coin = viewModel.getCoin(at: indexPath.row)
            cell.setupCell(with: coin)
        }
        return cell
    }
}

extension CryptoListVC: UISearchBarDelegate, UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.count != 0 {
            viewModel.filterCrypto(with: searchText)
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
        
        viewModel.clearFilteredCrypto()
        tableView.reloadData()
    }
}
