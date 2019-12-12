//
//  TotalValueCell.swift
//  Cryptofolio
//
//  Created by BZN8 on 26/11/2019.
//  Copyright © 2019 Dawid Bazan. All rights reserved.
//

import UIKit

class TotalValueCell: UITableViewCell {

    @IBOutlet var totalLbl: UILabel!
    
    func setupCell(with valueString: String) {
        totalLbl.text = valueString
    }
}
