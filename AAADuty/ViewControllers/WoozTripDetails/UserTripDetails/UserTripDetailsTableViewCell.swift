//
//  UserTripDetailsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

class UserTripDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 18
        roundedView.layer.borderWidth = 1
        roundedView.layer.borderColor = UIColor(red: 229/255, green: 87/255, blue: 87/255, alpha: 1).cgColor
        roundedView.layer.masksToBounds = true
    }
    
    func configureUI(title: String, description: String, imageName: String, hideLine: Bool = false) {
        imageOutlet.image = UIImage(named: imageName)
        titleOutlet.text = title
        descriptionOutlet.text = description
        if hideLine {
            lineView.isHidden = true
        }else {
            lineView.isHidden = false
        }
    }
}
