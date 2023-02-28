//
//  LocationTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import UIKit

protocol LocationTableViewCellDelegate: AnyObject {
    func backButtonTapped()
}

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var titleOutlet: AAALabel!
    
    weak var delegate: LocationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        notificationButton.setImage(UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.tintColor = UIColor.white
    }

    @IBAction func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
}
