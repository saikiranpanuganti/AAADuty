//
//  WaitingTimeCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 17/03/23.
//

import UIKit

protocol WaitingTimeCollectionViewCellDelegate: AnyObject {
    func waitingTimeTapped(waitingTime: WaitingTime?)
}

class WaitingTimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var timeUnitOutlet: UILabel!
    
    weak var delegate: WaitingTimeCollectionViewCellDelegate?
    var waitingTime: WaitingTime?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeView.layer.cornerRadius = 10
        timeView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeOutlet.text = " "
        timeUnitOutlet.text = " "
    }

    func configureUI(waitingTime: WaitingTime?) {
        self.waitingTime = waitingTime
        if let time = waitingTime?.waitingTime {
            timeOutlet.text = "\(time)"
            timeUnitOutlet.text = "MINS"
        }
        
        if waitingTime?.isSelected ?? false {
            timeView.layer.borderWidth = 2
            timeView.layer.borderColor = UIColor(red: 1, green: 127/255, blue: 0, alpha: 1).cgColor
        }else {
            timeView.layer.borderWidth = 0
            timeView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBAction func waitingTimeTapped() {
        delegate?.waitingTimeTapped(waitingTime: waitingTime)
    }
}
