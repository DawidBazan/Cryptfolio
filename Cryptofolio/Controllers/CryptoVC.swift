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
            self?.totalLbl.text = self?.viewModel.getTotalValue(for: crypto)
            self?.tableView.reloadData()
        }
    }
}

extension CryptoVC: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let frame = tableView.frame
//        let button = UIButton(frame: CGRectMake(5, 10, 15, 15))  // create button
//        button.tag = section
//        // the button is image - set image
//        button.setImage(UIImage(named: "remove_button"), forState: UIControlState.Normal)  // assumes there is an image named "remove_button"
//        button.addTarget(self, action: #selector(TestController.remove(_:)), forControlEvents: .TouchUpInside)  // add selector called by clicking on the button
//
//        let headerView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))  // create custom view
//        headerView.addSubview(button)   // add the button to the view
//
//        return headerView
//    }
    
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
