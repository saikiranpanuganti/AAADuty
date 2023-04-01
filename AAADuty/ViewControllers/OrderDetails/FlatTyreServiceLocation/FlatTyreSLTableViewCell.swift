//
//  FlatTyreSLTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

class FlatTyreSLTableViewCell: UITableViewCell {
    @IBOutlet weak var selectedAddressOutlet: UILabel!
    @IBOutlet weak var userAddressOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(requestDetailsModel: RequestDetailsModel?) {
        selectedAddressOutlet.text = requestDetailsModel?.response?.first?.desinationAddress
    }
}
