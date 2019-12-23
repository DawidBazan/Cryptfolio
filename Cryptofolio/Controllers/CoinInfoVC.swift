//
//  CoinInfoVC.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CoinInfoVC: UIViewController {
    @IBOutlet var chartView: ChartView!
    
    var viewModel: CoinInfoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.setupChart(with: viewModel.getPriceChanges())
    }
}

extension CoinInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CoinInfoCell
        return cell
    }
}
