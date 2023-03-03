//
//  ContinueTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol ContinueTableViewCellDelegate: AnyObject {
    func continueTapped()
}

class ContinueTableViewCell: UITableViewCell {
    @IBOutlet weak var continueButton: UIButton!
    
    weak var delegate: ContinueTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        continueButton.layer.cornerRadius = continueButton.frame.height/2
        continueButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        continueButton.layer.shadowOpacity = 1
        continueButton.layer.shadowOffset = .zero
        continueButton.layer.shadowRadius = 5
        continueButton.layer.masksToBounds = true
    }
    
    @IBAction func continueTapped() {
        delegate?.continueTapped()
    }
}
