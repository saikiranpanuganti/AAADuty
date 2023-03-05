//
//  FlatTyreViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import UIKit

class FlatTyreViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintType: ComplaintType?
    var selectedLocation: Location?
    var count: Int = 0
    var price: Int {
        return complaintType?.price ?? 0
    }
    var amount: Double {
        return Double(count*price)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "CountTableViewCell", bundle: nil), forCellReuseIdentifier: "CountTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(UINib(nibName: "LocationSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSelectionTableViewCell")
        
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
    
    func updateCountCell(withZero: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let countCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? CountTableViewCell {
                if withZero {
                    self.count = 1
                }
                countCell.configureUI(count: self.count, amount: self.amount)
            }
        }
    }
    
    func navigateToOrderConfirmationVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = Controllers.orderConfirmation.getController() as? OrderConfirmationViewController {
                controller.orderDetails = OrderDetails(category: self.category, totalAmount: Int(self.amount), address: self.selectedLocation, serviceDetails: self.complaintType?.complaint)
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
                        self.updateCountCell(withZero: true)
                    }catch {
                        print("Error: FlatTyreViewController getComplaintType - \(error.localizedDescription)")
                    }
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
        }
    }
}

extension FlatTyreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubServicesTableViewCell", for: indexPath) as? SubServicesTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category, subCategory: subCategories)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CountTableViewCell", for: indexPath) as? CountTableViewCell {
                cell.delegate = self
                cell.configureUI(count: count, amount: amount)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Location", address: selectedLocation?.address)
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell {
                return cell
            }
        }else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension FlatTyreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            return 170 + (screenWidth - 60)/3
        }
        return UITableView.automaticDimension
    }
}


extension FlatTyreViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension FlatTyreViewController: CountTableViewCellDelegate {
    func plusTapped() {
        if complaintType != nil {
            count += 1
            updateCountCell(withZero: false)
        }
    }
    func minusTapped() {
        if count > 0 {
            count -= 1
            updateCountCell(withZero: false)
        }
    }
}


extension FlatTyreViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        if selectedSubCategory?.id != subCategory?.id {
            selectedSubCategory = subCategory
            getComplaintType(categoryId: subCategory?.categoryID, typeID: subCategory?.id)
        }
    }
}


extension FlatTyreViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if amount == 0 {
            showAlert(title: "Error", message: "Select a service")
            return
        }else if selectedLocation == nil {
            showAlert(title: "Error", message: "Please select the location")
            return
        }
        checkAvailability()
    }
}


extension FlatTyreViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool) {
        if let mapsVc = Controllers.maps.getController() as? MapsViewController {
            mapsVc.pickUp = isFromPickUp
            mapsVc.delegate = self
            navigationController?.pushViewController(mapsVc, animated: true)
        }
    }
}


extension FlatTyreViewController: MapsViewControllerDelegate {
    func selectedLocation(location: Location?, pickUp: Bool) {
        if let location = location {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? LocationSelectionTableViewCell {
                selectedLocation = location
                cell.updateAddress(address: location.address)
            }
        }
    }
}
