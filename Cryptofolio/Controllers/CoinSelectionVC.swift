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
    
    var viewModel: CoinSelectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CoinSelectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CoinSelectionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
