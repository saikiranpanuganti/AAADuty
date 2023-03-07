//
//  StatusViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/03/23.
//

import UIKit

class StatusViewController: UIViewController {
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var areaOutlet: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationButton.setImage(UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.tintColor = UIColor.white
        
        LocationManager.shared.getAddress(asString: true) { [weak self] address, area in
            guard let self = self else { return }
            
            self.areaOutlet.text = area
            self.addressOutlet.text = address
        }
    }
    
    @IBAction func backButtonTapped() {
        
    }
    
    @IBAction func notificationsTapped() {
        
    }

    @IBAction func cancelRequestTapped() {
        
    }
}
