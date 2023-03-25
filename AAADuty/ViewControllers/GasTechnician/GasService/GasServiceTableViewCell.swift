//
//  GasServiceTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import UIKit

class GasServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    var complaintType: ComplaintType?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(complaintType: ComplaintType?) {
        self.complaintType = complaintType
        serviceOutlet.text = complaintType?.complaint
        priceOutlet.text = "\(complaintType?.price ?? 0)"
    }
}
