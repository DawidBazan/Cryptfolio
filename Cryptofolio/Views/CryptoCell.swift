//
//  CryptoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 10/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class CryptoCell: UITableViewCell {
    
    var cryptoImageView: UIImageView = {
        let this = UIImageView()
        return this
    }()
    var nameLebel: UILabel = {
        let this = UILabel()
        return this
    }()
    var fullPriceLebel: UILabel = {
        let this = UILabel()
        return this
    }()
    var priceChangeView: UIView = {
        let this = UIView()
        return this
    }()
    var priceChangeLebel: UILabel = {
        let this = UILabel()
        return this
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
    }
    
    private func setupLayout() {
        
    }
    
    func setupCell(with name: String, symbol: String, price: String, didPriceDrop: Bool, priceChangePercentage: String) {
        cryptoImageView.image = UIImage(named: name)
        nameLebel.text = symbol
        fullPriceLebel.text = price
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        if didPriceDrop {
            priceChangeView.backgroundColor = isDarkMode ? Constant.Colors.darkRed: Constant.Colors.lightRed
        } else {
            priceChangeView.backgroundColor = isDarkMode ? Constant.Colors.darkGreen: Constant.Colors.lightGreen
        }
        priceChangeLebel.text = priceChangePercentage
    }
}
