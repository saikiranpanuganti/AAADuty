//
//  MapsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapsViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelbutton : UIButton!
    @IBOutlet weak var searchtextfield : UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var searchResults: [GMSAutocompletePrediction] = []
    
    let token = GMSAutocompleteSessionToken.init()
    let filter = GMSAutocompleteFilter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 20.0
        
        let origImage = UIImage(named: "leftArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .black
        
        cancelbutton.isHidden = true

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        
        if let location = LocationManager.shared.getLocation() {
            mapView.clear()
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            let marker = GMSMarker(position: location.coordinate)
            marker.map = mapView
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
    
    @IBAction func cancelTapped(){
        searchtextfield.text = ""
        searchtextfield.resignFirstResponder()
        cancelbutton.isHidden = true
        searchResults = []
        DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
        }
    }
    
    @IBAction func textfieldIsEditing(_ textfield: UITextField){
        if textfield.text?.count == 0 {
            cancelbutton.isHidden = true
            
            searchResults = []
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        }else if let searchText  = textfield.text {
            cancelbutton.isHidden = false
            
            findAutoPredictPlaces(searchText: searchText)
        }
    }
    
    @IBAction func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func notificationTapped() {
        
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
                DispatchQueue.main.async {
                    self.searchResults = []
                    self.searchResultsTableView.reloadData()
                    print("Selected Place: Name - \(place.name) Co-ordiante - \(place.coordinate)")
                    
                    self.mapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                    let marker = GMSMarker(position: place.coordinate)
                    marker.map = self.mapView
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
