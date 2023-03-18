//
//  LocationSelectionTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol LocationSelectionTableViewCellDelegate: AnyObject {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String)
}

class LocationSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var locationTitle: UILabel!
    
    weak var delegate: LocationSelectionTableViewCellDelegate?
    
    var isFromPickUp: Bool = true
    var loctionTypeId: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(title: String, address: String?, pickUp: Bool = true, locationType: String = "") {
        isFromPickUp = pickUp
        locationTitle.text = title
        addressTextfield.text = address
        loctionTypeId = locationType
    }
    
    func updateAddress(address: String?) {
        addressTextfield.text = address
    }

    @IBAction func locationTapped() {
        delegate?.locationTapped(isFromPickUp: isFromPickUp, locationTypeId: loctionTypeId)
    }
    
}
