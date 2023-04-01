//
//  FlatTyreDetailsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

class FlatTyreDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var vehicleTypreLabel: UILabel!
    @IBOutlet weak var noOfTyresLabel: UILabel!
    @IBOutlet weak var OtherIssueLabel: UILabel!
    @IBOutlet weak var vehicleTypreOutlet: UILabel!
    @IBOutlet weak var noOfTyresOutlet: UILabel!
    @IBOutlet weak var OtherIssueOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(requestDetailsModel: RequestDetailsModel?) {
        vehicleTypreLabel.text = requestDetailsModel?.response?.first?.services?.first?.categoryName
        vehicleTypreOutlet.text = requestDetailsModel?.response?.first?.services?.first?.typeName
        noOfTyresLabel.text = requestDetailsModel?.response?.first?.services?.first?.complaint
        noOfTyresOutlet.text = requestDetailsModel?.response?.first?.services?.first?.noOfCount
        OtherIssueLabel.text = ""
        OtherIssueOutlet.text = ""
    }
}
