//
//  LocationTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import UIKit

protocol LocationTableViewCellDelegate: AnyObject {
    func backButtonTapped()
}

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var titleOutlet: AAALabel!
    @IBOutlet weak var addressOutlet: AAALabel!
    @IBOutlet weak var areaOutlet: AAALabel!
    
    weak var delegate: LocationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        notificationButton.setImage(UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.tintColor = UIColor.white
        
        LocationManager.shared.getAddress(asString: true) { [weak self] address, area, postalCode in
            guard let self = self else { return }
            
            self.areaOutlet.text = area
            self.addressOutlet.text = address
        }
    }
    
    func configureUI(title: String?) {
        titleOutlet.text = title
    }

    @IBAction func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
}
