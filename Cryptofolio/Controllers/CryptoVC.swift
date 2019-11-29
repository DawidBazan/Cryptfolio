//
//  ViewController.swift
//  Cryptofolio
//
//  Created by BZN8 on 21/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CryptoVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel: CryptoViewModel!
    var cryptoInfo: [CoinInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        viewModel.updatedCrypto = { [weak self] crypto in
            self?.cryptoInfo = crypto.info
            self?.tableView.reloadData()
        }
    }
    
    func addButtonToHeader(_ header: UITableViewHeaderFooterView) {
        let headerWidth = header.frame.width
        let button = UIButton(frame: CGRect(x: headerWidth - 35, y: 0, width: 20, height: 20))
        button.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        let image = UIImage(named: "add")
        button.setImage(image, for: .normal)
        header.addSubview(button)
    }
    
    @objc func addPressed() {
        performSegue(withIdentifier: "addCoin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCoin" {
            if let viewController = segue.destination as? AddCoinVC {
                viewController.cryptoInfo = cryptoInfo
            }
        }
    }
}

extension CryptoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            addButtonToHeader(headerView)
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
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "My Coins"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 80
        default:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return cryptoInfo.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CryptoCell
            cell.setupCell(with: cryptoInfo[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell") as! TotalValueCell
            let totalString = self.viewModel.getTotalValue(for: [1002, 1002])
            cell.setupCell(with: totalString)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
