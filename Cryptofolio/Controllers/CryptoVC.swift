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
    @IBOutlet var totalLbl: UILabel!
    
    var viewModel: CryptoViewModel!
    var cryptoInfo: [CryptoInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        viewModel.updatedCrypto = { [weak self] crypto in
            self?.cryptoInfo = crypto.info
            self?.cryptoInfo.forEach({ info in
                self?.viewModel.fetchImage(for: info.id)
            })
            self?.totalLbl.text = self?.viewModel.getTotalValue(for: crypto)
        }
        viewModel.updatedImage = { [weak self] imageData in
            guard let index = self?.cryptoInfo.firstIndex(where: {$0.id == imageData.id}) else { return }
            self?.cryptoInfo[index].image = imageData.data
            self?.tableView.reloadData()
        }
    }
}

extension CryptoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
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
        return "My Coins"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CryptoCell
        cell.setupCell(with: cryptoInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
