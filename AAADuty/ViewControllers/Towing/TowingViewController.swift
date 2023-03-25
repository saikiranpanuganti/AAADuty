//
//  TowingViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit

class TowingViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintType: ComplaintType?
    var pickUpLocation: Location?
    var dropLocation: Location?
    var carWashVendors: CarWashVendorsModel?
    
    var price: Int {
        return complaintType?.price ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "LocationSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSelectionTableViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getSubCategories()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func navigateToOrderConfirmationVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = Controllers.orderConfirmation.getController() as? OrderConfirmationViewController {
                LocationManager.shared.getLocationAndAddress { location in
                    controller.orderDetails = OrderDetails(category: self.category, totalAmount: self.price, pickUpAddress: self.pickUpLocation, dropAddress: self.dropLocation, complaintType: self.complaintType, userAddress: location, count: 0)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func navigateToCarWashVendorsVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = Controllers.carWashVendors.getController() as? CarWashVendorsViewController {
                controller.category = self.category
                controller.subCategories = self.subCategories
                controller.selectedSubCategory = self.selectedSubCategory
                controller.complaintType = self.complaintType
                controller.pickUpLocation = self.pickUpLocation
                controller.carWashVendors = self.carWashVendors
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    func getSubCategories() {
        if let categoryId = category?.id {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getTypes.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let subCategoryModel = try JSONDecoder().decode(SubCategoryModel.self, from: data)
                        self.subCategories = subCategoryModel
                        self.updateUI()
                    }catch {
                        print("Error: FlatTyreViewController getSubCategories - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getComplaintType(categoryId: String?, typeID: String?) {
        if let categoryId = categoryId, let typeID = typeID {
            showLoader()
            
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "TypeID": typeID]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getComplaintTypes.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let complaintTypeModel = try JSONDecoder().decode(ComplaintTypeModel.self, from: data)
                        self.complaintType = complaintTypeModel.complaintTypes?.first
                    }catch {
                        print("Error: FlatTyreViewController getComplaintType - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func checkAvailability() {
        if let categoryId = selectedSubCategory?.categoryID, let postalCodeStr = pickUpLocation?.postalCode, let postalCode = Int(postalCodeStr) {
            showLoader()
            
            let bodyParams: [String: Any] = ["pinCode": postalCode, "CategoryID": categoryId]
            NetworkAdaptor.requestWithHeaders(urlString: Url.checkRequestAvailability.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
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
                        print("Error: FlatTyreViewController checkAvailability - \(error.localizedDescription)")
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }else {
            self.showAlert(title: "Error", message: "Please selected type of towing")
        }
    }
    
    func getCarVendors() {
        if let coordinates = pickUpLocation?.getCoordinatesString(), let postalCodeStr = pickUpLocation?.postalCode {
            showLoader()
            
            let bodyParams: [String: Any] = ["pinCode": postalCodeStr, "coordinates": coordinates]
            
            NetworkAdaptor.requestWithHeaders(urlString: Url.getCarWashVendors.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data)
                        let carWashVendorsModel = try JSONDecoder().decode(CarWashVendorsModel.self, from: data)
                        self.carWashVendors = carWashVendorsModel
                        self.navigateToCarWashVendorsVC()
                    }catch {
                        print("Error: TowingViewController CarWash checkAvailability - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension TowingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                cell.configureUI(title: category?.categoryTitle)
                return cell
            }
        }else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubServicesTableViewCell", for: indexPath) as? SubServicesTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category, subCategory: subCategories)
                return cell
            }
        }else if indexPath.row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                if category?.serviceType == .carWash {
                    cell.configureUI(title: "Service Location", address: pickUpLocation?.address, pickUp: true)
                }else {
                    cell.configureUI(title: "Pickup Location", address: pickUpLocation?.address, pickUp: true)
                }
                
                return cell
            }
        }else if indexPath.row == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Drop Location", address: dropLocation?.address, pickUp: false)
                return cell
            }
        }else if indexPath.row == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell {
                return cell
            }
        }else if indexPath.row == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension TowingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }else if indexPath.row == 1 {
            return 170 + (screenWidth - 60)/3
        }
        return UITableView.automaticDimension
    }
}


extension TowingViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension TowingViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        if selectedSubCategory?.id != subCategory?.id {
            selectedSubCategory = subCategory
            getComplaintType(categoryId: subCategory?.categoryID, typeID: subCategory?.id)
        }
    }
}


extension TowingViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if category?.serviceType == .towing {
            if price == 0 {
                showAlert(title: "Error", message: "Please select a service")
                return
            }else if pickUpLocation == nil {
                showAlert(title: "Error", message: "Please select the pickup location")
                return
            }else if dropLocation == nil {
                showAlert(title: "Error", message: "Please select the drop location")
                return
            }else if pickUpLocation?.address == dropLocation?.address {
                showAlert(title: "Error", message: "Pickup location and drop location cannot be same")
                return
            }else {
                checkAvailability()
            }
        }else if category?.serviceType == .carWash {
            if selectedSubCategory == nil {
                showAlert(title: "Error", message: "Please select a vehicle type")
            }else if pickUpLocation == nil {
                showAlert(title: "Error", message: "Please select the pickup location")
                return
            }else if dropLocation == nil {
                showAlert(title: "Error", message: "Please select the drop location")
                return
            }else {
                getCarVendors()
            }
        }
    }
}


extension TowingViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String) {
        if let mapsVc = Controllers.maps.getController() as? MapsViewController {
            mapsVc.pickUp = isFromPickUp
            mapsVc.delegate = self
            navigationController?.pushViewController(mapsVc, animated: true)
        }
    }
}


extension TowingViewController: MapsViewControllerDelegate {
    func selectedLocation(location: Location?, pickUp: Bool, locationTypeId: String) {
        if pickUp {
            if let location = location {
                if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? LocationSelectionTableViewCell {
                    pickUpLocation = location
                    cell.updateAddress(address: location.address)
                }
            }
        }else {
            if let location = location {
                if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? LocationSelectionTableViewCell {
                    dropLocation = location
                    cell.updateAddress(address: location.address)
                }
            }
        }
    }
}
