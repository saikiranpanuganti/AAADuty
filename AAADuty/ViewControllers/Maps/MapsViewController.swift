//
//  MapsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

struct Location: Codable {
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var placeName: String?
    var postalCode: String?
    
    func getCoordinatesString() -> String? {
        if let latitude = latitude, let longitude = longitude {
            return "\(latitude),\(longitude)"
        }
        return nil
    }
}


protocol MapsViewControllerDelegate: AnyObject {
    func selectedLocation(location: Location?, pickUp: Bool)
}

class MapsViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelbutton : UIButton!
    @IBOutlet weak var searchtextfield : UITextField!
    @IBOutlet weak var searchResultsView: UIView!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var searchResults: [GMSAutocompletePrediction] = []
    
    let token = GMSAutocompleteSessionToken.init()
    let filter = GMSAutocompleteFilter()
    var destinationMarker: GMSMarker?
    var pickUp: Bool = true
    
    weak var delegate: MapsViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 20.0
        confirmButton.layer.cornerRadius = 10.0
        
        let origImage = UIImage(named: "leftArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .black
        
        cancelbutton.isHidden = true
        searchResultsView.isHidden = true

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        
        if let location = LocationManager.shared.getLocation() {
            mapView.clear()
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            mapView.delegate = self
            
            destinationMarker = GMSMarker(position: location.coordinate)
            destinationMarker?.map = mapView
        }
    }
    
    func findAutoPredictPlaces(searchText: String) {
        let placesClient = GMSPlacesClient()
        
        placesClient.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: token) { results, error in
            if let results = results {
                self.searchResults = results
                DispatchQueue.main.async {
                    self.searchResultsTableView.reloadData()
                }
            }
        }
    }
    
    func setAddress(coordinates: CLLocationCoordinate2D?, _ completion: @escaping ((String?, String?, String?) -> ())) {
        if let coordinates = coordinates {
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler:{ [weak self] (placemarks, error) in
//                guard let self = self else {
//                    completion(nil, "Something went wrong")
//                    return
//                }
                
                if error != nil {
                    completion(nil, "Error fetching address", nil)
                }else {
                    let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                            
                    if ((p.subThoroughfare) != nil) {
                        subThoroughfare = (p.subThoroughfare)!
                    }
                    if ((p.thoroughfare) != nil) {
                        thoroughfare = p.thoroughfare!
                    }
                    if ((p.subAdministrativeArea) != nil) {
                        subAdministrativeArea = p.subAdministrativeArea!
                    }
                    if ((p.subLocality) != nil) {
                        subLocality = p.subLocality!
                    }
                    if ((p.postalCode) != nil) {
                        postalCode = p.postalCode!
                    }
                    if ((p.country) != nil) {
                        country = p.country!
                    }
                    
                    completion("\(subThoroughfare) \(thoroughfare) \(subLocality) \(subAdministrativeArea) \(postalCode) \(country)", nil, "\(postalCode)")
                }
            })
        }else {
            completion(nil, "Unable to fetch address", nil)
        }
    }
    
    @IBAction func cancelTapped(){
        searchtextfield.text = ""
        searchtextfield.resignFirstResponder()
        cancelbutton.isHidden = true
        searchResultsView.isHidden = true
        searchResults = []
        DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
        }
    }
    
    @IBAction func textfieldIsEditing(_ textfield: UITextField){
        if textfield.text?.count == 0 {
            cancelbutton.isHidden = true
            searchResultsView.isHidden = true
            
            searchResults = []
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        }else if let searchText  = textfield.text {
            cancelbutton.isHidden = false
            searchResultsView.isHidden = false
            
            findAutoPredictPlaces(searchText: searchText)
        }
    }
    
    @IBAction func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func notificationTapped() {
        
    }
    
    @IBAction func confirmTapped() {
        if let latitude = destinationMarker?.position.latitude, let longitude = destinationMarker?.position.longitude {
            setAddress(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) { [weak self] address, error, pincode in
                guard let self = self else { return }
                
                self.delegate?.selectedLocation(location: Location(latitude: latitude, longitude: longitude, address: address, postalCode: pincode), pickUp: self.pickUp)
                
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
}


extension MapsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "MapResultTableViewCell", for: indexPath) as? MapResultTableViewCell {
            cell.address.text = searchResults[indexPath.row].attributedFullText.string
            return cell
        }
        return UITableViewCell()
    }
    
    
}
extension MapsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = searchResults[indexPath.row]
        
        GMSPlacesClient().lookUpPlaceID(place.placeID) { place, error in
            if let place = place {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.searchtextfield.text = place.formattedAddress
                    self.searchResults = []
                    self.searchResultsView.isHidden = true
                    self.searchtextfield.resignFirstResponder()
                    self.searchResultsTableView.reloadData()
                    
                    self.mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                    self.destinationMarker = GMSMarker(position: place.coordinate)
                    self.destinationMarker?.map = self.mapView
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension MapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt position - \(position.target)")
        searchtextfield.isEnabled = true
        
        setAddress(coordinates: CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)) { address, error, postalCode in
            if let address = address {
                self.searchtextfield.text = address
                self.cancelbutton.isHidden = false
            }else if let error = error {
                self.searchtextfield.text = error
                self.cancelbutton.isHidden = false
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        searchtextfield.isEnabled = false
        let destinationLocation = CLLocation(latitude: position.target.latitude,  longitude: position.target.longitude)
        updateLocationoordinates(coordinates: destinationLocation.coordinate)
        if searchtextfield.isFirstResponder {
            searchtextfield.resignFirstResponder()
        }
    }
    
    func updateLocationoordinates(coordinates:CLLocationCoordinate2D) {
        if destinationMarker == nil {
            destinationMarker = GMSMarker()
            destinationMarker?.position = coordinates
            destinationMarker?.map = mapView
            destinationMarker?.appearAnimation = GMSMarkerAnimation.pop
        }else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            destinationMarker?.position =  coordinates
            CATransaction.commit()
        }
    }
}
