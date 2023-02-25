//
//  ProfileTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var roundBorder: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var roundedViewCenterY: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundBorder.layer.cornerRadius = 70
        roundBorder.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        roundBorder.backgroundColor = UIColor.clear
        roundBorder.layer.borderWidth = 1.0
        roundBorder.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        profileImageView.layer.masksToBounds = true
        
        roundedViewCenterY.constant = (topSafeAreaHeight/2)*0.9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
