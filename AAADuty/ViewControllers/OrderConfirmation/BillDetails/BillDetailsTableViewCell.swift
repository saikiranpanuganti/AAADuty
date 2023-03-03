//
//  BillDetailsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

class BillDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var baseAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(amount: Int) {
        baseAmount.text = "\(amount)"
        totalAmount.text = "\(amount)"
    }
}
