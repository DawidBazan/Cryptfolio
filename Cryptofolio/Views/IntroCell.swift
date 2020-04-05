//
//  IntroCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 17/12/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class IntroCell: UITableViewCell {
    private let cryptoImageView: UIImageView = {
        let this = UIImageView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.contentMode = .scaleAspectFit
        return this
    }()
    private let nameLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        return this
    }()
    private let amountLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.textAlignment = .right
        return this
    }()
    private let stackView: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .horizontal
        this.alignment = .fill
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
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(amountLabel)
        addSubview(cryptoImageView)
        addSubview(stackView)
    }
    
    private func setupLayout() {
        cryptoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cryptoImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 50).isActive = true
        cryptoImageView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -10).isActive = true
        cryptoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cryptoImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: cryptoImageView.trailingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupCell(with coin: Cryptocurrency) {
        cryptoImageView.imageFromCrypto(coin.name)
        nameLabel.text = coin.name
        if coin.amount > 0 {
            amountLabel.text = "\(coin.amount)"
        } else {
            amountLabel.text = ""
        }
    }
}
