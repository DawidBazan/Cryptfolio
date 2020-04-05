//
//  IntroSelectionView.swift
//  Cryptofolio
//
//  Created by Dawid on 21/03/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import UIKit

class IntroView: UIView {
    let doneButton: UIButton = {
        let this = UIButton()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.setTitleColor(.orange, for: .normal)
        this.setTitle("Done", for: .normal)
        return this
    }()
    let titleLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        this.textAlignment = .center
        return this
    }()
    let descriptionLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 16)
        this.textAlignment = .center
        this.numberOfLines = 0
        return this
    }()
    let tableView: UITableView = {
        let this = UITableView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.allowsMultipleSelection = true
        this.allowsMultipleSelectionDuringEditing = true
        this.separatorStyle = .none
        this.rowHeight = 80
        return this
    }()
    let stackView: UIStackView = {
        let this = UIStackView()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.axis = .vertical
        this.alignment = .center
        this.distribution = .fillEqually
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
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addSubview(doneButton)
        addSubview(stackView)
        addSubview(tableView)
    }
    
    private func setupLayout() {
        doneButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        doneButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.topAnchor.constraint(equalTo: doneButton.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
