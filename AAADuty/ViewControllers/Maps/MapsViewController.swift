//
//  MapsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelbutton : UIButton!
    @IBOutlet weak var searchtextfield : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 20.0
        
        let origImage = UIImage(named: "leftArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .black
        
        cancelbutton.isHidden = true

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let gsmMapView = GMSMapView.map(withFrame: mapView.frame, camera: camera)
        mapView.addSubview(gsmMapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = gsmMapView
    }
    
    @IBAction func cancelTapped(){
        searchtextfield.text = ""
        searchtextfield.resignFirstResponder()
        cancelbutton.isHidden = true
    }
    
    @IBAction func textfieldIsEditing(_ textfield: UITextField){
        if textfield.text?.count == 0 {
            cancelbutton.isHidden = true
        }else {
            cancelbutton.isHidden = false
        }
    }
    
    @IBAction func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func notificationTapped() {
        
    }
}
