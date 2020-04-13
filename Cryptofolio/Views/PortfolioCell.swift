//
//  CryptoCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 22/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class PortfolioCell: UITableViewCell {
    let cryptoImageView: UIImageView = {
        let this = UIImageView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.contentMode = .scaleAspectFit
        return this
    }()
    let nameLebel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        return this
    }()
    let fullPriceLebel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        return this
    }()
    let coinAmountLebel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.textAlignment = .right
        return this
    }()
    let coinValueLebel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.textAlignment = .right
        return this
    }()
    let nameAndPriceStack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .vertical
        this.distribution = .equalSpacing
        return this
    }()
    let amountAndValueStack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .vertical
        this.distribution = .equalSpacing
        return this
    }()
    let stack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .horizontal
        this.distribution = .fillEqually
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
        nameAndPriceStack.addArrangedSubview(nameLebel)
        nameAndPriceStack.addArrangedSubview(fullPriceLebel)
        amountAndValueStack.addArrangedSubview(coinAmountLebel)
        amountAndValueStack.addArrangedSubview(coinValueLebel)
        stack.addArrangedSubview(nameAndPriceStack)
        stack.addArrangedSubview(amountAndValueStack)
        addSubview(cryptoImageView)
        addSubview(stack)
    }
    
    private func setupLayout() {
        cryptoImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        cryptoImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        cryptoImageView.trailingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        cryptoImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: cryptoImageView.trailingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    func setupCell(with name: String, price: String, amount: String, value: String) {
        cryptoImageView.image = UIImage(named: name)
        nameLebel.text = name
        fullPriceLebel.text = price
        coinAmountLebel.text = amount
        coinValueLebel.text = value
    }
}
