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
}

class TransitionTableViewCell: UITableViewCell {
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var automaticView: UIView!
    @IBOutlet weak var manualCircleView: UIView!
    @IBOutlet weak var automaticCircleView: UIView!
    
    weak var delegate: TransitionTableViewCellDelegate?

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
    }
    
    @IBAction func manualTapped() {
        manualCircleView.backgroundColor = UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1)
        automaticCircleView.backgroundColor = UIColor.white
        delegate?.manualTapped()
    }
    
    @IBAction func automaticTapped() {
        automaticCircleView.backgroundColor = UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1)
        manualCircleView.backgroundColor = UIColor.white
        delegate?.automaticTapped()
    }
}
