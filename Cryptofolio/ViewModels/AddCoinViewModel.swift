//
//  AddCoinViewModel.swift
//  Cryptofolio
//
//  Created by BZN8 on 12/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import Foundation

class AddCoinViewModel {
    
    private let crypto: [CoinInfo]
    private var selectedCoin: CoinInfo?
    var updatedSelection: (() -> Void)?
    
    init(crypto: [CoinInfo]) {
        self.crypto = crypto
        self.selectedCoin = crypto.first
    }
    
    func getRowCount() -> Int {
        return crypto.count
    }
    
    func getCountForActionSheet() -> Int { // to display a maximum of 3 options in the action sheet
        if crypto.count > 2 {
            return 3
        } else {
            return crypto.count
        }
    }
    
    func addSelectedCoin(amount: Double) {
        guard let selectedCoin = selectedCoin else { return }
        CoreDataHandler.addCoin(selectedCoin, amount: amount)
    }
    
    func getCoin(at index: Int) -> CoinInfo {
        return crypto[index]
    }
    
    func getSelectedCoin() -> CoinInfo? {
        return selectedCoin
    }
    
    func setSelectedCoin(to coin: CoinInfo?) {
        selectedCoin = coin
    }
    
    func createCoinSelectionVM() -> CoinSelectionViewModel {
        let viewModel = CoinSelectionViewModel(crypto: crypto)
        viewModel.updateSelection = { [weak self] coin in
            self?.selectedCoin = coin
            self?.updatedSelection?()
        }
        return viewModel
    }
}
