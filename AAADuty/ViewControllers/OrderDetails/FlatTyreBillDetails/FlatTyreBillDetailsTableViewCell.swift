//
//  FlatTyreBillDetailsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

class FlatTyreBillDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var amountOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(requestDetailsModel: RequestDetailsModel?) {
        amountOutlet.text = "\(requestDetailsModel?.response?.first?.totalAmount ?? 0)"
    }
}
