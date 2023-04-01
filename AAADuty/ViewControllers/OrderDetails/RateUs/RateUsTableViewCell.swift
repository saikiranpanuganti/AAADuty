//
//  RateUsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

protocol RateUsTableViewCellDelegate: AnyObject {
    
}

class RateUsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOutlet1: UIImageView!
    @IBOutlet weak var imageOutlet2: UIImageView!
    @IBOutlet weak var imageOutlet3: UIImageView!
    @IBOutlet weak var imageOutlet4: UIImageView!
    @IBOutlet weak var imageOutlet5: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegate: RateUsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        submitButton.layer.cornerRadius = 30
        submitButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        submitButton.layer.shadowOpacity = 1
        submitButton.layer.shadowOffset = .zero
        submitButton.layer.shadowRadius = 5
    }
    
    @IBAction func star1Tapped() {
        imageOutlet1.image = UIImage(named: "starFilled")
        imageOutlet2.image = UIImage(named: "starUnfilled")
        imageOutlet3.image = UIImage(named: "starUnfilled")
        imageOutlet4.image = UIImage(named: "starUnfilled")
        imageOutlet5.image = UIImage(named: "starUnfilled")
    }
    @IBAction func star2Tapped() {
        imageOutlet1.image = UIImage(named: "starFilled")
        imageOutlet2.image = UIImage(named: "starFilled")
        imageOutlet3.image = UIImage(named: "starUnfilled")
        imageOutlet4.image = UIImage(named: "starUnfilled")
        imageOutlet5.image = UIImage(named: "starUnfilled")
    }
    @IBAction func star3Tapped() {
        imageOutlet1.image = UIImage(named: "starFilled")
        imageOutlet2.image = UIImage(named: "starFilled")
        imageOutlet3.image = UIImage(named: "starFilled")
        imageOutlet4.image = UIImage(named: "starUnfilled")
        imageOutlet5.image = UIImage(named: "starUnfilled")
    }
    @IBAction func star4Tapped() {
        imageOutlet1.image = UIImage(named: "starFilled")
        imageOutlet2.image = UIImage(named: "starFilled")
        imageOutlet3.image = UIImage(named: "starFilled")
        imageOutlet4.image = UIImage(named: "starFilled")
        imageOutlet5.image = UIImage(named: "starUnfilled")
    }
    @IBAction func star5Tapped() {
        imageOutlet1.image = UIImage(named: "starFilled")
        imageOutlet2.image = UIImage(named: "starFilled")
        imageOutlet3.image = UIImage(named: "starFilled")
        imageOutlet4.image = UIImage(named: "starFilled")
        imageOutlet5.image = UIImage(named: "starFilled")
    }
    
    @IBAction func submitTapped() {
        
    }
}
