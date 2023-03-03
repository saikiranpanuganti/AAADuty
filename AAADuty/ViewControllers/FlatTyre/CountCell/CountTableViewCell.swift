//
//  CountTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol CountTableViewCellDelegate: AnyObject {
    func plusTapped()
    func minusTapped()
}

class CountTableViewCell: UITableViewCell {
    @IBOutlet weak var roundedView: AAAView!
    @IBOutlet weak var countOutlet: UILabel!
    @IBOutlet weak var totalAmountOutlet: UILabel!
    
    weak var delegate: CountTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 20.0
        roundedView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        roundedView.layer.shadowOpacity = 1
        roundedView.layer.shadowOffset = .zero
        roundedView.layer.shadowRadius = 10
    }
    
    func configureUI() {
        
    }
    
    @IBAction func plusTapped() {
        delegate?.plusTapped()
    }
    
    @IBAction func minusTapped() {
        delegate?.minusTapped()
    }
}
