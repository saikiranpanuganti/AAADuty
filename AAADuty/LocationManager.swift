//
//  LocationManager.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import Foundation
import CoreLocation


protocol LocationManagerDelegate: AnyObject {
    func deniedLocationAccess()
}


class LocationManager: NSObject {
    
    static let shared: LocationManager = LocationManager()
    
    private var locationManager: CLLocationManager?
    weak var delegate: LocationManagerDelegate?
    
    private override init() {
        super.init()
        
//        setUpLocationManager()
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if locationManager?.authorizationStatus == .authorizedAlways || locationManager?.authorizationStatus == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }else {
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    func getLocation() -> CLLocation? {
        return locationManager?.location
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.requestLocation()
            locationManager?.startUpdatingLocation()
            print("Authorized")
        }else if status == .denied {
            delegate?.deniedLocationAccess()
        }else {
            print("Show Alert - \(status.rawValue)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude {
            print("Location: \(location)")
            return
        }
    }
    
    // Below Method will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error - \(error)")
    }
}
