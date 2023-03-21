//
//  ServiceOrderTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 19/03/23.
//

import UIKit

class ServiceOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var labelOutlet: UILabel!
    
    var cleaningService: CleaningService?
    var complaintType: ComplaintType?
    var location: Location?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        greenView.layer.cornerRadius = 7
        greenView.layer.masksToBounds = true
    }
    
    func configureUI(cleaningService: CleaningService?) {
        self.cleaningService = cleaningService
        labelOutlet.text = cleaningService?.serviceName
        labelOutlet.textColor = UIColor.black
    }
    
    func configureUI(complaintType: ComplaintType?) {
        self.complaintType = complaintType
        labelOutlet.text = complaintType?.complaint
        labelOutlet.textColor = UIColor.black
    }
    
    func configureUI(location: Location?) {
        self.location = location
        labelOutlet.text = location?.address
        labelOutlet.textColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
    }
}
