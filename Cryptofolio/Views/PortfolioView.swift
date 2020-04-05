//
//  PortfolioView.swift
//  Cryptofolio
//
//  Created by Dawid on 29/03/2020.
//  Copyright © 2020 Dawid Bazan. All rights reserved.
//

import UIKit

class PlatformView: UIView {
    let totalTitleLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        this.textAlignment = .center
        return this
    }()
    let totalLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 16)
        this.textAlignment = .center
        this.numberOfLines = 0
        return this
    }()
    let totalChangeLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 16)
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
    let AddLabel: UILabel = {
        let this = UILabel()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.font = UIFont.systemFont(ofSize: 16)
        this.textAlignment = .center
        this.numberOfLines = 0
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
        return this
    }()
    let bottomSheet: UIViewController = PortfolioSheetVC()
    
    init() {
        super.init(frame: .zero)
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
}
