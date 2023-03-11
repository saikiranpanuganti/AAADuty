//
//  CarVendorTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 10/03/23.
//

import UIKit

protocol CarVendorTableViewCellDelegate: AnyObject {
    func carVendorConfirmTapped(carWashVendor: CarWashVendor?)
}

class CarVendorTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    weak var delegate: CarVendorTableViewCellDelegate?
    
    var carWashVendor: CarWashVendor?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        confirmButton.layer.cornerRadius = 15
        
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.29).cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 10
    }
    
    func configureUI(carWashVendor: CarWashVendor?) {
        self.carWashVendor = carWashVendor
        nameOutlet.text = carWashVendor?.companyName
        addressOutlet.text = carWashVendor?.address
        
        if carWashVendor?.isSelected ?? false {
            applyBorderColor()
        }else {
            clearBorderColor()
        }
    }
    
    func applyBorderColor() {
        shadowView.layer.borderColor = UIColor(named: "orangeAppColor")?.cgColor
        shadowView.layer.borderWidth = 1
    }
    
    func clearBorderColor() {
        shadowView.layer.borderColor = UIColor.clear.cgColor
        shadowView.layer.borderWidth = 0
    }
    
    @IBAction func carVendorConfirmTapped() {
        delegate?.carVendorConfirmTapped(carWashVendor: carWashVendor)
    }
}
