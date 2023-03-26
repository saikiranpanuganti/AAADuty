//
//  BookingsHeaderTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import UIKit

protocol BookingsHeaderTableViewCellDelegate: AnyObject {
    func backButtonTapped()
}

class BookingsHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameView: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var areaOutlet: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileViewLeading: NSLayoutConstraint!
    
    weak var delegate: BookingsHeaderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileView.layer.cornerRadius = 24
        profileView.layer.masksToBounds = true
        
        profileImage.image = UIImage(named: "profileTab")?.withRenderingMode(.alwaysTemplate)
        profileImage.tintColor = UIColor.white
        
        profileNameView.layer.cornerRadius = 11
        profileNameView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
//        [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        profileName.text = AppData.shared.user?.customerName ?? "Guest"
        
        notificationImage.image = UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate)
        notificationImage.tintColor = UIColor.white
        
        headerView.layer.cornerRadius = 45
        headerView.layer.masksToBounds = true
        
        LocationManager.shared.getAddress(asString: true) { [weak self] address, area, postalCode in
            guard let self = self else { return }
            
            self.areaOutlet.text = area
            self.addressOutlet.text = address
        }
    }
    
    func configureUI(hideBackButton: Bool) {
        if hideBackButton {
            backButton.isHidden = true
            profileViewLeading.constant = 25
        }else {
            backButton.isHidden = false
            profileViewLeading.constant = 55
        }
    }
    
    @IBAction func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}
