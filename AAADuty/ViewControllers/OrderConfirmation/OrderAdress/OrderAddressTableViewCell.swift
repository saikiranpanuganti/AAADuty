//
//  OrderAddressTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol OrderAddressTableViewCellDelegate: AnyObject {
    func editTapped()
}

class OrderAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var greenView1: UIView!
    @IBOutlet weak var greenView2: UIView!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var serviceDetails: UILabel!
    @IBOutlet weak var serviceAmount: UILabel!
    
    weak var delegate: OrderAddressTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        greenView1.layer.cornerRadius = 7
        greenView2.layer.cornerRadius = 7
        serviceAmount.isHidden = true
    }
    
    func configureUI(orderDetails: OrderDetails?) {
        if let orderDetails = orderDetails {
            serviceName.text = orderDetails.category?.category
            serviceIcon.sd_setImage(with: URL(string: orderDetails.category?.requestImageURL ?? ""))
            addressOutlet.text = orderDetails.address?.address ?? "No address available"
            serviceDetails.text = orderDetails.complaintType?.complaint ?? ""
            serviceAmount.text = ""
        }
    }
    
    func configureUI(orderDetails_VT: OrderDetails?) {
        if let orderDetails = orderDetails_VT {
            serviceName.text = orderDetails.category?.category
            serviceIcon.sd_setImage(with: URL(string: orderDetails.category?.requestImageURL ?? ""))
            addressOutlet.text = orderDetails.address?.address ?? "No address available"
            serviceDetails.text = orderDetails.vehicleProblem?.problem
            serviceAmount.isHidden = false
            serviceAmount.text = "₹\(orderDetails.totalAmount ?? 0)"
        }
    }
    
    @IBAction func editTapped() {
        delegate?.editTapped()
    }
}
