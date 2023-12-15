//
//  GasTechnicianViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 20/03/23.
//

import UIKit

class GasTechnicianViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintTypes: [ComplaintType]?
    var selectedComplaintTypes: [ComplaintType] = []
    var selectedLocation: Location?
    var comments: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "ServiceTypesTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceTypesTableViewCell")
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
    
    func setSelectedSubCategory(subCategory: SubCategory?) {
        if let id = subCategory?.id {
            for index in 0..<(subCategories?.categories?.count ?? 0) {
                if subCategories?.categories?[index].id == id {
                    subCategories?.categories?[index].isSelected = true
                }else {
                    subCategories?.categories?[index].isSelected = false
                }
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
                        print("Error: CleaningViewController getSubCategories - \(error.localizedDescription)")
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
                        self.complaintTypes = complaintTypeModel.complaintTypes
                        self.updateUI()
                    }catch {
                        print("Error: FlatTyreViewController getComplaintType - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


extension GasTechnicianViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.configureUI(title: category?.categoryTitle)
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTypesTableViewCell", for: indexPath) as? ServiceTypesTableViewCell {
                cell.delegate = self
                cell.configureUI(complaintTypes: complaintTypes, title: "Select Service Type", height: 110)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Service Location", address: selectedLocation?.address)
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell {
                cell.delegate = self
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
extension GasTechnicianViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            return 170 + (screenWidth - 60)/3
        }else if indexPath.section == 2 {
            if complaintTypes?.count ?? 0 == 0 {
                return 0
            }else {
                let rows: Int = (((complaintTypes?.count ?? 0)/3) + ((((complaintTypes?.count ?? 0) % 3) == 0) ? 0 : 1))
                return CGFloat(50 + rows*120)
            }
        }
        
        return UITableView.automaticDimension
    }
}


extension GasTechnicianViewController: LocationTableViewCellDelegate {
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


extension GasTechnicianViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String) {
        if let mapsVc = Controllers.maps.getController() as? MapsViewController {
            mapsVc.pickUp = isFromPickUp
            mapsVc.delegate = self
            navigationController?.pushViewController(mapsVc, animated: true)
        }
    }
}


extension GasTechnicianViewController: MapsViewControllerDelegate {
    func selectedLocation(location: Location?, pickUp: Bool, locationTypeId: String) {
        if let location = location {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? LocationSelectionTableViewCell {
                selectedLocation = location
                cell.updateAddress(address: location.address)
            }
        }
    }
}


extension GasTechnicianViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        if selectedSubCategory?.id != subCategory?.id {
            selectedSubCategory = subCategory
            setSelectedSubCategory(subCategory: subCategory)
            getComplaintType(categoryId: subCategory?.categoryID, typeID: subCategory?.id)
        }
    }
}


extension GasTechnicianViewController: ServiceTypesTableViewCellDelegate {
    func subCategoryTypeTapped(subCategoryType: SubCategoryType?) {
        
    }
    func complaintTypeTapped(complaintType: ComplaintType?) {
        if let complaintType = complaintType {
            if complaintType.isSelected {
                let filteredComplaintTypes = selectedComplaintTypes.filter { $0.id == complaintType.id }
                if filteredComplaintTypes.count <= 0 {
                    selectedComplaintTypes.append(complaintType)
                }
            }else {
                selectedComplaintTypes.removeAll { $0.id == complaintType.id }
            }
        }
    }
}


extension GasTechnicianViewController: CommentsTableViewCellDelegate {
    func commentsEntered(comments: String?) {
        self.comments = comments
    }
}


extension GasTechnicianViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        selectedComplaintTypes.removeAll { $0.isSelected == false }
        
        if selectedSubCategory != nil {
            if selectedComplaintTypes.count > 0 {
                if selectedLocation != nil {
                    if let controller = Controllers.cleaningOrderDetails.getController() as? CleaningOrderDetailsViewController {
                        controller.category = category
                        controller.subCategories = subCategories
                        controller.selectedSubCategory = selectedSubCategory
                        controller.selectedLocation = selectedLocation
                        controller.comments = comments
                        controller.complaintTypes = complaintTypes
                        controller.selectedComplaintTypes = selectedComplaintTypes
                        navigationController?.pushViewController(controller, animated: true)
                    }
                }else {
                    showAlert(title: "Error", message: "Please select service location")
                }
            }else {
                showAlert(title: "Error", message: "Please select a service type")
            }
        }else {
            showAlert(title: "Error", message: "Please select a property type")
        }
        
    }
}
