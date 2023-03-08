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
    
    var userCurrentAddress: String = ""
    
    var isAuthorized: Bool {
        if locationManager?.authorizationStatus == .authorizedAlways || locationManager?.authorizationStatus == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
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
    
    func getLocationAndAddress(_ completion: @escaping ((Location?) -> ())) {
        if let location = getLocation() {
            getAddress(asString: true) { address, area, postalCode in
                completion(Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, address: address, placeName: area, postalCode: postalCode))
            }
        }else {
            completion(nil)
        }
    }
    
    
    func getAddress(asString: Bool, _ completion: @escaping ((String, String, String) -> ())) {
        if let myLocation = locationManager?.location {
            CLGeocoder().reverseGeocodeLocation(myLocation, completionHandler:{(placemarks, error) in
                if error != nil {
                    completion(error.debugDescription, "", "")
                }else {
                    let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                    var area:String = ""
                    var address:String = ""
                            
                    if ((p.subThoroughfare) != nil) {
                        subThoroughfare = (p.subThoroughfare)!
                    }
                    if ((p.thoroughfare) != nil) {
                        thoroughfare = p.thoroughfare!
                        area = thoroughfare
                    }
                    if ((p.subAdministrativeArea) != nil) {
                        subAdministrativeArea = p.subAdministrativeArea!
                        area = subAdministrativeArea
                    }
                    if ((p.subLocality) != nil) {
                        subLocality = p.subLocality!
                        area = subLocality
                    }
                    if ((p.postalCode) != nil) {
                        postalCode = p.postalCode!
                    }
                    if ((p.country) != nil) {
                        country = p.country!
                    }
                    
                    
                    if asString {
                        address = "\(subThoroughfare) \(thoroughfare) \(subLocality) \(subAdministrativeArea) \(postalCode) \(country)"
                    }else {
                        address =  "\(subThoroughfare) \(thoroughfare)\n\(subLocality) \(subAdministrativeArea) \(postalCode)\n\(country)"
                    }
                    completion(address, area, postalCode)
                }
            })
        }else {
            completion("No location available", "Location not available", "")
        }
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
        if let location = locations.last {
            print("Location: \(location)")
            return
        }
    }
    
    // Below Method will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error - \(error)")
    }
}
