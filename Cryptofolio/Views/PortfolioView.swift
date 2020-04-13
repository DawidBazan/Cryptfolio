//
//  PortfolioView.swift
//  Cryptofolio
//
//  Created by Dawid on 29/03/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import UIKit

class PortfolioView: UIView {
    let totalTitleLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        this.textAlignment = .center
        this.text = "Total value"
        return this
    }()
    let totalLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 35)
        this.textAlignment = .center
        this.numberOfLines = 0
        return this
    }()
    let totalChangeLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 17)
        this.textAlignment = .center
        this.numberOfLines = 0
        return this
    }()
    let addButton: UIButton = {
        let this = UIButton()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.setImage(#imageLiteral(resourceName: "add.png"), for: .normal)
        this.contentMode = .scaleAspectFit
        return this
    }()
    let addLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 16)
        this.textAlignment = .center
        this.numberOfLines = 0
        this.text = "Add"
        return this
    }()
    let historyButton: UIButton = {
        let this = UIButton()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.setImage(#imageLiteral(resourceName: "history"), for: .normal)
        this.contentMode = .scaleAspectFit
        return this
    }()
    let historyLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 16)
        this.textAlignment = .center
        this.numberOfLines = 0
        this.text = "History"
        return this
    }()
    let totalStack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .vertical
        this.distribution = .fill
        this.alignment = .center
        this.spacing = 5
        return this
    }()
    let buttonsStack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .horizontal
        this.distribution = .fillEqually
        this.alignment = .center
        return this
    }()
    let addStack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .vertical
        this.distribution = .fill
        this.alignment = .fill
        this.spacing = 5
        return this
    }()
    let historyStack: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .vertical
        this.distribution = .fill
        this.alignment = .fill
        this.spacing = 5
        return this
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        totalStack.addArrangedSubview(totalTitleLabel)
        totalStack.addArrangedSubview(totalLabel)
        totalStack.addArrangedSubview(totalChangeLabel)
        addStack.addArrangedSubview(addButton)
        addStack.addArrangedSubview(addLabel)
        historyStack.addArrangedSubview(historyButton)
        historyStack.addArrangedSubview(historyLabel)
        buttonsStack.addArrangedSubview(addStack)
        buttonsStack.addArrangedSubview(historyStack)
        addSubview(totalStack)
        addSubview(buttonsStack)
    }
    
    private func setupLayout() {
        totalStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        totalStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        totalStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        totalStack.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -100).isActive = true
        buttonsStack.topAnchor.constraint(equalTo: totalStack.bottomAnchor, constant: 100).isActive = true
        buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

