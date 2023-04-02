//
//  TransitionTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 08/03/23.
//

import UIKit

protocol TransitionTableViewCellDelegate: AnyObject {
    func manualTapped()
    func automaticTapped()
    func transitionTapped(complaintType: ComplaintType?)
}

extension TransitionTableViewCellDelegate {
    func manualTapped() {  }
    func automaticTapped() {  }
    func transitionTapped(complaintType: ComplaintType?) {  }
}

class TransitionTableViewCell: UITableViewCell {
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var automaticView: UIView!
    @IBOutlet weak var manualCircleView: UIView!
    @IBOutlet weak var automaticCircleView: UIView!
    @IBOutlet weak var manualImage: UIImageView!
    @IBOutlet weak var automaticImage: UIImageView!
    @IBOutlet weak var manualLabel: UILabel!
    @IBOutlet weak var automaticLabel: UILabel!
    @IBOutlet weak var manualInnerCircleView: UIView!
    @IBOutlet weak var automaticInnerCircleView: UIView!
    
    
    weak var delegate: TransitionTableViewCellDelegate?
    
    var complaintTypes: [ComplaintType]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        manualView.layer.cornerRadius = 25
        manualView.layer.masksToBounds = true
        automaticView.layer.cornerRadius = 25
        automaticView.layer.masksToBounds = true
        
        manualCircleView.layer.cornerRadius = 18
        manualCircleView.layer.masksToBounds = true
        automaticCircleView.layer.cornerRadius = 18
        automaticCircleView.layer.masksToBounds = true
        
        manualCircleView.layer.borderWidth = 3
        manualCircleView.layer.borderColor = UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1).cgColor
        automaticCircleView.layer.borderWidth = 3
        automaticCircleView.layer.borderColor = UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1).cgColor
        
        manualInnerCircleView.layer.cornerRadius = 10
        automaticInnerCircleView.layer.cornerRadius = 10
        manualInnerCircleView.isHidden = true
        automaticInnerCircleView.isHidden = true
    }
    
    func configureUI(complaintTypes: [ComplaintType]?) {
        if let complaintTypes = complaintTypes {
            self.complaintTypes = complaintTypes
            if complaintTypes.count > 1 {
                manualImage.sd_setImage(with: URL(string: complaintTypes[0].imageURL ?? ""))
                manualLabel.text = complaintTypes[0].complaint
                automaticImage.sd_setImage(with: URL(string: complaintTypes[1].imageURL ?? ""))
                automaticLabel.text = complaintTypes[1].complaint
            }
        }
    }
    
    @IBAction func manualTapped() {
        manualInnerCircleView.isHidden = false
        automaticInnerCircleView.isHidden = true
        if complaintTypes?.count ?? 0 > 1 {
            delegate?.transitionTapped(complaintType: complaintTypes?[0])
        }else {
            delegate?.manualTapped()
        }
    }
    
    @IBAction func automaticTapped() {
        manualInnerCircleView.isHidden = true
        automaticInnerCircleView.isHidden = false
        if complaintTypes?.count ?? 0 > 1 {
            delegate?.transitionTapped(complaintType: complaintTypes?[1])
        }else {
            delegate?.automaticTapped()
        }
    }
}
