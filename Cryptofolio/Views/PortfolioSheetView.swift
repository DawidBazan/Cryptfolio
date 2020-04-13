//
//  PortfolioSheetView.swift
//  Cryptofolio
//
//  Created by Dawid on 04/04/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import UIKit

class PortfolioSheetView: UIView {
    private let panView: UIView = {
        let this = UIView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.backgroundColor = .lightGray
        this.layer.cornerRadius = 3
        return this
    }()
    private let handleView: UIView = {
        let this = UIView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.backgroundColor = .white
        this.layer.cornerRadius = 5
        return this
    }()
    let tableView: UITableView = {
        let this = UITableView()
        this.translatesAutoresizingMaskIntoConstraints = false
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
        handleView.addSubview(panView)
        addSubview(handleView)
        addSubview(tableView)
    }
    
    private func setupLayout() {
        panView.topAnchor.constraint(equalTo: handleView.topAnchor, constant: 5).isActive = true
        panView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor).isActive = true
        panView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        panView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        handleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        handleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        handleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tableView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: -20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
