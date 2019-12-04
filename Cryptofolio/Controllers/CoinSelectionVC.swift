//
//  AddCoinVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 27/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinSelectionVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var cryptoInfo: [CoinInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.isEditing = true
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "addAmount", let viewController = segue.destination as? AddCoinVC else { return }
        if let index = tableView.indexPathForSelectedRow {
            viewController.selectedCoin = cryptoInfo?[index.row]
        }
    }
}

extension CoinSelectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let crypto = cryptoInfo {
            return crypto.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CoinSelectionCell
        cell.setupCell(with: cryptoInfo![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addAmount", sender: self)
//        let selectedCellsIndexes = tableView.indexPathsForSelectedRows
//        selectedCellsIndexes?.forEach({ index in
//            guard index != indexPath else { return }
//            let cell = tableView.cellForRow(at: index)
//            cell?.isSelected = false
//        })
    }
}
