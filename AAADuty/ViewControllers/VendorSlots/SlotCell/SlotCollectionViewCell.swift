//
//  SlotCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/04/23.
//

import UIKit

class SlotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    var slot: Slot?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 10
        roundedView.layer.borderWidth = 1
        roundedView.layer.borderColor = UIColor.clear.cgColor
        roundedView.layer.masksToBounds = true
    }

    func configureUI(slot: Slot?) {
        self.slot = slot
        timeLabel.text = slot?.startTime
        if slot?.isSelected ?? false {
            roundedView.layer.borderColor = UIColor(named: "orangeAppColor")?.cgColor
        }else {
            roundedView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
