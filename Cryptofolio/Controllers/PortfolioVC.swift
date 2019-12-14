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
    @IBOutlet var chartView: ChartView!
    @IBOutlet var cardView: CardView!
    
    var viewModel: PortfolioViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        cardView.setupCard(in: self)
        viewModel.updatedCrypto = { [weak self] in
            self?.totalValueLbl.text = self?.viewModel.getTotalValue()
            if self?.viewModel.getTotalsCount() ?? 0 > 10 {
                self?.chartView.setupChart(with: (self?.viewModel.getMyTotals())!)
            }
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        performSegue(withIdentifier: "addCoin", sender: self)
    }
    
    @IBAction func historyPressed(_ sender: Any) {
        performSegue(withIdentifier: "history", sender: self)
    }
    
    @IBAction func detailsPressed(_ sender: Any) {
        performSegue(withIdentifier: "details", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCoin" {
            if let viewController = segue.destination as? AddCoinVC {
                viewController.viewModel = viewModel.createAddCoinVM()
                viewController.coinAdded = { [weak self] in
                    self?.viewModel.getMyCrypto()
                }
            }
        }
        if segue.identifier == "history" {
            if let viewController = segue.destination as? HistoryVC {
                viewController.viewModel = viewModel.createHistoryVM()
            }
        }
    }
}

extension PortfolioVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
//            addButtonToHeader(headerView)
            customHeaderView(for: headerView)
        }
    }
    
    func customHeaderView(for headerView: UITableViewHeaderFooterView) {
        if #available(iOS 13.0, *) {
            headerView.contentView.backgroundColor = .systemBackground
            headerView.backgroundView?.backgroundColor = .systemBackground
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
