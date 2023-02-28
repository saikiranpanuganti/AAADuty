//
//  LocationManager.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import Foundation
import CoreLocation


class LocationManager: NSObject {
    
    static let shared: LocationManager = LocationManager()
    
    private var locationManager: CLLocationManager?
    
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
        if status == .authorizedAlways {
            print("Authorized")
        }else if status == .denied {
            print("Show Alert - Denied")
        }else {
            print("Show Alert - \(status.rawValue)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude {
            AppData.shared.userLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return
        }
    }
    
    // Below Method will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error - \(error)")
    }
}
