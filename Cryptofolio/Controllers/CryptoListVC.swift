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
    var crypto: [CoinInfo] = []
    var filteredCrypto: [CoinInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        viewModel.fetchCrypto()
    }
    
    func viewSetup() {
        makeSearchBar()
        viewModel.updatedCrypto = { [weak self] crypto in
            self?.crypto = crypto.info
            self?.tableView.reloadData()
        }
    }
    
    func makeSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.showsCancelButton = false
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.keyboardAppearance = .dark
        search.searchBar.tintColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension CryptoListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCrypto.isEmpty {
            return crypto.count
        } else {
            return filteredCrypto.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CryptoCell
        if filteredCrypto.isEmpty {
            cell.setupCell(with: crypto[indexPath.row])
        } else {
            cell.setupCell(with: filteredCrypto[indexPath.row])
        }
        return cell
    }
}

extension CryptoListVC: UISearchBarDelegate, UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.count != 0 {
            let filtered = crypto.filter({ $0.name.lowercased().contains(searchText.lowercased())})
            self.filteredCrypto = filtered
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
        
        filteredCrypto.removeAll()
        tableView.reloadData()
    }
}
