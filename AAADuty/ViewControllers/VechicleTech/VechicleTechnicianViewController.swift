//
//  VechicleTechnicianViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 08/03/23.
//

import UIKit

class VechicleTechnicianViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    
    var vechicleTypes: VechicleTypeModel?
    var selectedVehicleType: VechicleType?
    
    var vechicleTypeSelection: Bool = false
    var vechicleSubTypeSelection: Bool = false
    
    var isManualTransition: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        if vechicleSubTypeSelection {
            tableView.register(UINib(nibName: "TransitionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransitionTableViewCell")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if vechicleTypeSelection {
            getSubCategories()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
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
    
    func getVechicleTypes(categoryId: String?, typeID: String?) {
        if let categoryId = categoryId, let typeID = typeID {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "typeID": typeID]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getVechicleType.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let vechicleTypeModel = try JSONDecoder().decode(VechicleTypeModel.self, from: data)
                        self.vechicleTypes = vechicleTypeModel
                        
                        DispatchQueue.main.async {
                            if let controller = Controllers.vechicleTech.getController() as? VechicleTechnicianViewController {
                                controller.category = self.category
                                controller.subCategories = self.subCategories
                                controller.selectedSubCategory = self.selectedSubCategory
                                controller.vechicleTypes = self.vechicleTypes
                                controller.selectedVehicleType = self.selectedVehicleType
                                controller.vechicleSubTypeSelection = true
                                
                                self.navigationController?.pushViewController(controller, animated: false)
                            }
                        }
                    }catch {
                        print("Error: FlatTyreViewController getSubCategories - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getVechicleBrands(categoryId: String?, typeID: String?, vehicleTypeID: String?) {
        if let categoryId = categoryId, let typeID = typeID, let vehicleTypeID = vehicleTypeID {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "typeID": typeID, "VehicleTypeID": vehicleTypeID]
            print("bodyParams - \(bodyParams)")
            NetworkAdaptor.requestWithHeaders(urlString: Url.getVehicleBrands.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let vechicleBrandsModel = try JSONDecoder().decode(VechicleBrandsModel.self, from: data)
                        DispatchQueue.main.async {
                            if let controller = Controllers.vehicleBrands.getController() as? VehicleBrandsViewController {
                                controller.category = self.category
                                controller.subCategories = self.subCategories
                                controller.selectedSubCategory = self.selectedSubCategory
                                controller.vechicleTypes = self.vechicleTypes
                                controller.selectedVehicleType = self.selectedVehicleType
                                controller.vehicleBrands = vechicleBrandsModel
                                
                                self.navigationController?.pushViewController(controller, animated: false)
                            }
                        }
                    }catch {
                        print("Error: FlatTyreViewController getSubCategories - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getContinueCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
            cell.title = "NEXT"
            cell.font = UIFont(name: "Segoe-UI-SemiBold", size: 18)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func getTransitionCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransitionTableViewCell", for: indexPath) as? TransitionTableViewCell {
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension VechicleTechnicianViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if vechicleTypeSelection {
            return 3
        }else if vechicleSubTypeSelection {
            if vechicleTypes?.response?.first?.typeID == "62bacecf4ee3da924a2d4eac" {
                return 3
            }else {
                return 4
            }
        }
        return 0
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
                if vechicleTypeSelection {
                    cell.configureUI(category: category, subCategory: subCategories)
                }else if vechicleSubTypeSelection {
                    cell.configureUI(category: category, vehicleType: vechicleTypes)
                }
                return cell
            }
        }else if indexPath.section == 2 {
            if vechicleTypeSelection {
                return getContinueCell(indexPath: indexPath)
            }else if vechicleSubTypeSelection {
                if vechicleTypes?.response?.first?.typeID == "62bacecf4ee3da924a2d4eac" {
                    return getContinueCell(indexPath: indexPath)
                }else {
                    return getTransitionCell(indexPath: indexPath)
                }
            }
        }else if indexPath.section == 3 {
            return getContinueCell(indexPath: indexPath)
        }
        return UITableViewCell()
    }
}
extension VechicleTechnicianViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            if vechicleTypeSelection {
                let rows: Int = (((subCategories?.categories?.count ?? 0)/3) + ((((subCategories?.categories?.count ?? 0) % 3) == 0) ? 0 : 1))
                return 170 + (((screenWidth)/3)*CGFloat(rows))
            }else if vechicleSubTypeSelection {
                let rows: Int = (((vechicleTypes?.response?.count ?? 0)/3) + ((((vechicleTypes?.response?.count ?? 0) % 3) == 0) ? 0 : 1))
                return 170 + (((screenWidth)/3)*CGFloat(rows))
            }
        }
        return UITableView.automaticDimension
    }
}


extension VechicleTechnicianViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension VechicleTechnicianViewController: SubServicesTableViewCellDelegate {
    func vehicleTypeTapped(vehicleType: VechicleType?) {
        if selectedVehicleType?.id != vehicleType?.id {
            selectedVehicleType = vehicleType
        }
    }
    
    func subServiceTapped(subCategory: SubCategory?) {
        if selectedSubCategory?.id != subCategory?.id {
            selectedSubCategory = subCategory
        }
    }
}


extension VechicleTechnicianViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if vechicleTypeSelection {
            if selectedSubCategory == nil {
                showAlert(title: "Error", message: "Select a vechicle type")
                return
            }else {
                getVechicleTypes(categoryId: selectedSubCategory?.categoryID, typeID: selectedSubCategory?.id)
            }
        }else if vechicleSubTypeSelection {
            if selectedVehicleType == nil {
                if vechicleTypes?.response?.first?.typeID == "62bacecf4ee3da924a2d4eac" {
                    showAlert(title: "Error", message: "Select a Bike type")
                }else {
                    showAlert(title: "Error", message: "Select a Car type")
                }
                return
            }else if isManualTransition == nil && vechicleTypes?.response?.first?.typeID != "62bacecf4ee3da924a2d4eac" {
                showAlert(title: "Error", message: "Select the transmission type")
            }else {
                getVechicleBrands(categoryId: selectedVehicleType?.categoryID, typeID: selectedVehicleType?.typeID, vehicleTypeID: selectedVehicleType?.id)
            }
        }
    }
}


extension VechicleTechnicianViewController: TransitionTableViewCellDelegate {
    func manualTapped() {
        isManualTransition = true
    }
    func automaticTapped() {
        isManualTransition = false
    }
}
