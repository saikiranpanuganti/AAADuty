//
//  PastOrderTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/03/23.
//

import UIKit

class PastOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var closeImageOutlet: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    
    var pastOrder: PastOrder?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 2
        
        imageBackgroundView.layer.cornerRadius = 16
        imageBackgroundView.layer.borderColor = UIColor.red.cgColor
        imageBackgroundView.layer.borderWidth = 1
        imageBackgroundView.layer.masksToBounds = true
    }
    
    func configureUI(pastOrder: PastOrder?) {
        self.pastOrder = pastOrder
        statusLabel.text = pastOrder?.paymentStatus
        paymentStatusLabel.text = pastOrder?.requestStatus?.capitalized
        priceLabel.text = "₹ \(pastOrder?.totalAmount ?? 0)"
        if let dateStr = pastOrder?.date {
            dateTimeLabel.text = dateStr.toDate(.isoDateTimeMilliSec)?.getDateString(format: "MMM dd, hh:mm a")
        }
        if pastOrder?.paymentStatus == "Failed" {
            imageBackgroundView.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
            closeImageOutlet.image = UIImage(named: "failed")
            closeImageOutlet.isHidden = false
            imageOutlet.isHidden = true
        }else {
            imageBackgroundView.layer.borderColor = UIColor(red: 30/255, green: 163/255, blue: 2/155, alpha: 1).cgColor
            imageOutlet.image = UIImage(named: "success")
            closeImageOutlet.isHidden = true
            imageOutlet.isHidden = false
        }
    }
}
