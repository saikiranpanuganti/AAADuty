//
//  LocationSelectionTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol LocationSelectionTableViewCellDelegate: AnyObject {
    func locationTapped()
}

class LocationSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var locationTitle: UILabel!
    
    weak var delegate: LocationSelectionTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(title: String) {
        locationTitle.text = title
    }

    @IBAction func locationTapped() {
        delegate?.locationTapped()
    }
    
}
