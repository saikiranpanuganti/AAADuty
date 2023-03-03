//
//  PaymentModeTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit

class PaymentModeTableViewCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(amount: Int) {
        amountLabel.text = "\(amount)"
    }
}
