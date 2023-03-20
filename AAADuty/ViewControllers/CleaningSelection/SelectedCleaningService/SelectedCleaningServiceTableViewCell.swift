//
//  SelectedCleaningServiceTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 19/03/23.
//

import UIKit

class SelectedCleaningServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceOutlet: UILabel!
    @IBOutlet weak var serviceAmount: UILabel!
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var countOutlet: UILabel!
    
    var cleaningService: CleaningService?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        plusMinusView.layer.cornerRadius = 18
        plusMinusView.layer.masksToBounds = true
        plusMinusView.layer.borderWidth = 1
        plusMinusView.layer.borderColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1).cgColor
    }
    
    func configureUI(cleaningService: CleaningService?) {
        if let cleaningService = cleaningService {
            self.cleaningService = cleaningService
            countOutlet.text = "\(cleaningService.count)"
            serviceAmount.text = "\(cleaningService.count*(cleaningService.price ?? 0))"
            serviceOutlet.text = cleaningService.serviceName
        }
    }
    
    @IBAction func minusTapped() {
        
    }
    @IBAction func plusTapped() {
        
    }
}
