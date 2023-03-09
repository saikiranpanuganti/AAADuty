//
//  LabelTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

class LabelTableViewCell: UITableViewCell {
    @IBOutlet weak var labelOutlet: UILabel!
    
    var vehicle: Vechicle?
    var vehicleProblem: VechicleProblem?

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
    
}
