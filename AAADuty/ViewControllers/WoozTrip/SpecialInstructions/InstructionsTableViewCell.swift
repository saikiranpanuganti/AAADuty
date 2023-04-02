//
//  InstructionsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 17/03/23.
//

import UIKit

protocol InstructionsTableViewCellDelegate: AnyObject {
    func kidsTapped(selected: Bool)
    func womenTapped(selected: Bool)
    func srCitizenTapped(selected: Bool)
}

class InstructionsTableViewCell: UITableViewCell {
    @IBOutlet weak var kidsView: UIView!
    @IBOutlet weak var womenView: UIView!
    @IBOutlet weak var srCitizenView: UIView!
    @IBOutlet weak var kidsButton: UIButton!
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var srCitizenButton: UIButton!

    weak var delegate: InstructionsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        kidsButton.tag = 0
        womenButton.tag = 0
        srCitizenButton.tag = 0
    }
    
    @IBAction func kidsTapped() {
        if kidsButton.tag == 0 {
            kidsButton.tag = 1
            kidsButton.setImage(UIImage(named: "tick"), for: .normal)
            kidsButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            delegate?.kidsTapped(selected: true)
        }else {
            kidsButton.tag = 0
            kidsButton.setImage(nil, for: .normal)
            kidsButton.backgroundColor = UIColor.clear
            delegate?.kidsTapped(selected: false)
        }
    }
    @IBAction func womenTapped() {
        if womenButton.tag == 0 {
            womenButton.tag = 1
            womenButton.setImage(UIImage(named: "tick"), for: .normal)
            womenButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            delegate?.womenTapped(selected: true)
        }else {
            womenButton.tag = 0
            womenButton.setImage(nil, for: .normal)
            womenButton.backgroundColor = UIColor.clear
            delegate?.womenTapped(selected: false)
        }
    }
    @IBAction func srCitizenTapped() {
        if srCitizenButton.tag == 0 {
            srCitizenButton.tag = 1
            srCitizenButton.setImage(UIImage(named: "tick"), for: .normal)
            srCitizenButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            delegate?.srCitizenTapped(selected: true)
        }else {
            srCitizenButton.tag = 0
            srCitizenButton.setImage(nil, for: .normal)
            srCitizenButton.backgroundColor = UIColor.clear
            delegate?.srCitizenTapped(selected: false)
        }
    }
}
