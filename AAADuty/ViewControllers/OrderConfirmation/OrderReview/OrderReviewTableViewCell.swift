//
//  OrderReviewTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol OrderReviewTableViewCellDelegate: AnyObject {
    func overviewTapped()
    func readPolicyTapped()
    func makePaymentTapped()
}

class OrderReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var paymentButton: UIButton!
    
    weak var delegate: OrderReviewTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        paymentButton.layer.cornerRadius = 10
        paymentButton.layer.masksToBounds = true
    }
    
    @IBAction func overviewTapped() {
        delegate?.overviewTapped()
    }
    
    @IBAction func readPolicyTapped() {
        delegate?.readPolicyTapped()
    }
    
    @IBAction func makePaymentTapped() {
        delegate?.makePaymentTapped()
    }
}
