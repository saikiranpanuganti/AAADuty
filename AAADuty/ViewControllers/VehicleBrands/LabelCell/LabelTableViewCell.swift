//
//  LabelTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var labelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var labelBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var labelLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var labelRightAnchor: NSLayoutConstraint!
    
    var vehicle: Vechicle?
    var vehicleProblem: VechicleProblem?
    var canclReason: CancelReason?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(vechicle: Vechicle?) {
        vehicle = vechicle
        labelOutlet.text = vehicle?.vehicleName
    }
    
    func configureUI(vechicleProblem: VechicleProblem?) {
        vehicleProblem = vechicleProblem
        labelOutlet.text = vechicleProblem?.problem
    }
    
    func configureUI(cancelReason: CancelReason?) {
        labelTopAnchor.constant = 8
        labelBottomAnchor.constant = 8
        labelLeftAnchor.constant = 20
        labelRightAnchor.constant = 20
        
        canclReason = cancelReason
        labelOutlet.text = cancelReason?.reason
        
        labelBackgroundView.backgroundColor = UIColor(red: 232/255, green: 243/255, blue: 254/255, alpha: 1)
        
        labelBackgroundView.layer.cornerRadius = 10
        labelBackgroundView.layer.borderWidth = 1
        labelBackgroundView.layer.masksToBounds = true
        
        if cancelReason?.isSelected ?? false {
            labelBackgroundView.layer.borderColor = UIColor(named: "orangeAppColor")?.cgColor
        }else {
            labelBackgroundView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
