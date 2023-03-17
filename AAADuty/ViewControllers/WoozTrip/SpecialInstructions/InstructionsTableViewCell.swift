//
//  InstructionsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 17/03/23.
//

import UIKit

protocol InstructionsTableViewCellDelegate: AnyObject {
    func kidsTapped()
    func womenTapped()
    func srCitizenTapped()
}

class InstructionsTableViewCell: UITableViewCell {
    @IBOutlet weak var kidsView: UIView!
    @IBOutlet weak var womenView: UIView!
    @IBOutlet weak var srCitizenView: UIView!

    weak var delegate: InstructionsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func kidsTapped() {
        delegate?.kidsTapped()
    }
    @IBAction func womenTapped() {
        delegate?.womenTapped()
    }
    @IBAction func srCitizenTapped() {
        delegate?.srCitizenTapped()
    }
}
