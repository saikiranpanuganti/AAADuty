//
//  TowingDetailsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit

protocol TowingDetailsTableViewCellDelegate: AnyObject {
    func towingEditTapped()
}

class TowingDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var greenView1: UIView!
    @IBOutlet weak var greenView2: UIView!
    @IBOutlet weak var greenView3: UIView!
    @IBOutlet weak var pickUpAddress: UILabel!
    @IBOutlet weak var dropAddress: UILabel!
    @IBOutlet weak var serviceDetails: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    weak var delegate: TowingDetailsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        greenView1.layer.cornerRadius = 7
        greenView2.layer.cornerRadius = 7
        greenView3.layer.cornerRadius = 7
    }
    
    func configureUI(orderDetails: OrderDetails?) {
        if let orderDetails = orderDetails {
            serviceName.text = orderDetails.category?.category
            serviceIcon.sd_setImage(with: URL(string: orderDetails.category?.requestImageURL ?? ""))
            pickUpAddress.text = orderDetails.pickUpAddress?.address ?? "Pick Up address not available"
            dropAddress.text = orderDetails.dropAddress?.address ?? "Drop address not available"
            serviceDetails.text = orderDetails.complaintType?.complaint ?? ""
            priceOutlet.text = "\(orderDetails.totalAmount ?? 0)"
        }
    }

    @IBAction func editTapped() {
        delegate?.towingEditTapped()
    }
    
}
