//
//  StatusViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/03/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class StatusViewController: UIViewController {
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var areaOutlet: UILabel!
    
    var orderDetails: OrderDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationButton.setImage(UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.tintColor = UIColor.white
        
        cancelView.layer.cornerRadius = 50
        cancelView.layer.borderWidth = 1
        cancelView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        cancelButton.layer.masksToBounds = true
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.layer.borderColor = UIColor(red: 1, green: 127/255, blue: 0, alpha: 1).cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.masksToBounds = true
        
        LocationManager.shared.getAddress(asString: true) { [weak self] address, area in
            guard let self = self else { return }
            
            self.areaOutlet.text = area
            self.addressOutlet.text = address
        }
        
        if let latitude = orderDetails?.address?.latitude, let longitude = orderDetails?.address?.longitude {
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.clear()
            mapView.camera = GMSCameraPosition(target: coordinates, zoom: 15, bearing: 0, viewingAngle: 0)
            
            let destinationMarker = GMSMarker(position: coordinates)
            destinationMarker.map = mapView
        }
    }
    
    @IBAction func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationsTapped() {
        
    }

    @IBAction func cancelRequestTapped() {
        
    }
}
