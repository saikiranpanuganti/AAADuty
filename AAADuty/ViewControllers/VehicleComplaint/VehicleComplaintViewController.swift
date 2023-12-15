//
//  VehicleComplaintViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

class VehicleComplaintViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTableViewBackground: UIView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    
    var vechicleTypes: VechicleTypeModel?
    var selectedVehicleType: VechicleType?
    
    var vehicleBrands: VechicleBrandsModel?
    var selectedVehicleBrand: VechicleBrand?
    
    var vehicles: VechiclesModel?
    var selectedVehicle: Vechicle?
    
    var vehicleProblems: VechicleProblemModel?
    var selectedVehicleProblem: VechicleProblem?
    
    var isManualTransition: Bool?
    
    var selectedLocation: Location?
    var searchResults: [VechicleProblem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(UINib(nibName: "LocationSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSelectionTableViewCell")
        tableView.register(UINib(nibName: "VehicleProblemsTableViewCell", bundle: nil), forCellReuseIdentifier: "VehicleProblemsTableViewCell")
        
        searchTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchTableViewBackground.layer.cornerRadius = 8
        searchTableViewBackground.layer.masksToBounds = true
        searchView.isHidden = true
        
        continueButton.layer.cornerRadius = 22
        continueButton.layer.masksToBounds = true
        
        searchResults = vehicleProblems?.response ?? []
    }
    
    func navigateToOrderConfirmationVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = Controllers.orderConfirmation.getController() as? OrderConfirmationViewController {
                LocationManager.shared.getLocationAndAddress { location in
                    controller.orderDetails = OrderDetails(category: self.category, totalAmount: Int(self.selectedVehicleProblem?.price ?? 0), address: self.selectedLocation, vehicleProblem: self.selectedVehicleProblem, userAddress: location, count: 1, isManualTransmission: self.isManualTransition, vehicleType: self.selectedVehicleType, subCategory: self.selectedSubCategory, vehicle: self.selectedVehicle)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func checkAvailability() {
        if let categoryId = selectedSubCategory?.categoryID, let postalCodeStr = selectedLocation?.postalCode, let postalCode = Int(postalCodeStr) {
            showLoader()
            
            let bodyParams: [String: Any] = ["pinCode": postalCode, "CategoryID": categoryId]
            
            NetworkAdaptor.requestWithHeaders(urlString: Url.checkRequestAvailability.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader {
                    if let data = data {
                        do {
                            if let responseJson = try JSONSerialization.jsonObject(with: data) as? [String: Any], let message = responseJson["Message"] as? String {
                                if message == "Please Take A Request For Today" {
                                    self.navigateToOrderConfirmationVC()
                                }else {
                                    self.showAlert(title: "Error", message: message)
                                }
                            }else {
                                self.showAlert(title: "Error", message: "Something went wrong")
                            }
                        }catch {
                            print("Error: VehicleComplaintViewController checkAvailability - \(error.localizedDescription)")
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func hideSearchView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.searchView.alpha = 0
        } completion: { [weak self] bool in
            guard let self = self else { return }
            self.searchView.isHidden = true
        }
    }
    
    @IBAction func closeSearchView() {
        hideSearchView()
    }
    
    @IBAction func searchContinue() {
        hideSearchView()
    }

    @IBAction func textfieldIsEditing(_ textfield: UITextField){
        if textfield.text?.count == 0 {
            searchResults = vehicleProblems?.response ?? []
            searchTableView.reloadData()
        }else if let searchText  = textfield.text?.lowercased() {
            searchResults = vehicleProblems?.response?.filter({ $0.problem?.lowercased().contains(searchText) ?? false }) ?? []
            searchTableView.reloadData()
        }
    }
}


extension VehicleComplaintViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchTableView {
            return 1
        }
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return searchResults.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell {
                cell.configureUI(vechicleProblem: searchResults[indexPath.row])
                return cell
            }
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                cell.configureUI(title: category?.categoryTitle)
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleProblemsTableViewCell", for: indexPath) as? VehicleProblemsTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category, vehicleProblems: vehicleProblems)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell {
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Location", address: selectedLocation?.address)
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.continueButton.setTitle("NEXT", for: .normal)
                cell.continueButton.titleLabel?.font = UIFont(name: "Segoe-UI-SemiBold", size: 18)
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension VehicleComplaintViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView {
            return 40
        }
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            return CGFloat(160 + (40*(vehicleProblems?.response?.count ?? 0)))
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            selectedVehicleProblem = searchResults[indexPath.row]
            searchTextfield.text = searchResults[indexPath.row].problem
            
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VehicleProblemsTableViewCell {
                cell.updateText(text: searchResults[indexPath.row].problem)
            }
            
            hideSearchView()
        }
    }
}


extension VehicleComplaintViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    func notificationsTapped() {
        let notificationsVC = Controllers.notificationsVC.getController()
        notificationsVC.modalPresentationStyle = .fullScreen
        notificationsVC.modalTransitionStyle = .crossDissolve
        self.present(notificationsVC, animated: true)
    }
}


extension VehicleComplaintViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if selectedVehicleProblem == nil {
            
        }else if selectedLocation == nil {
            
        }else {
            checkAvailability()
        }
    }
}


extension VehicleComplaintViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String) {
        if let mapsVc = Controllers.maps.getController() as? MapsViewController {
            mapsVc.pickUp = isFromPickUp
            mapsVc.locationTypeId = locationTypeId
            mapsVc.delegate = self
            navigationController?.pushViewController(mapsVc, animated: true)
        }
    }
}


extension VehicleComplaintViewController: MapsViewControllerDelegate {
    func selectedLocation(location: Location?, pickUp: Bool, locationTypeId: String) {
        if let location = location {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? LocationSelectionTableViewCell {
                selectedLocation = location
                cell.updateAddress(address: location.address)
            }
        }
    }
}


extension VehicleComplaintViewController: VehicleProblemsTableViewCellDelegate {
    func vehicleProblemSelected(vehicleProblem: VechicleProblem?) {
        if selectedVehicleProblem?.id != vehicleProblem?.id {
            selectedVehicleProblem = vehicleProblem
        }
    }
    func searchTapped() {
        searchView.alpha = 0
        searchView.isHidden = false
        searchTableView.reloadData()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.searchView.alpha = 1
        }
    }
}
