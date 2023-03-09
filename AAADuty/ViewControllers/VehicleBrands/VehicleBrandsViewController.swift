//
//  VehicleBrandsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

class VehicleBrandsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
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
    
    var searchResults: [Vechicle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        searchTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        searchView.layer.cornerRadius = 5
        searchView.layer.masksToBounds = true
        searchView.isHidden = true
        
        continueButton.layer.cornerRadius = 22
        continueButton.layer.masksToBounds = true
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func updateSearchSection() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
    }

    func getVechicles(categoryId: String?, typeID: String?, vehicleTypeID: String?, brandID: String?) {
        if let categoryId = categoryId, let typeID = typeID, let vehicleTypeID = vehicleTypeID, let brandID = brandID {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "typeID": typeID, "VehicleTypeID": vehicleTypeID, "BrandID": brandID]
            print("bodyParams - \(bodyParams)")
            NetworkAdaptor.requestWithHeaders(urlString: Url.getVehicles.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let vechiclesModel = try JSONDecoder().decode(VechiclesModel.self, from: data)
                        self.vehicles = vechiclesModel
                        self.searchResults = vechiclesModel.response ?? []
                        self.selectedVehicle = nil
                        self.updateSearchSection()
                    }catch {
                        print("Error: VehicleBrandsViewController getVechicles - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getVehicleProblems(categoryId: String?, typeID: String?, vehicleTypeID: String?) {
        if let categoryId = categoryId, let typeID = typeID, let vehicleTypeID = vehicleTypeID {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "typeID": typeID, "VehicleTypeID": vehicleTypeID]
            print("bodyParams - \(bodyParams)")
            NetworkAdaptor.requestWithHeaders(urlString: Url.getVehicleProblems.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let vechicleProblemsModel = try JSONDecoder().decode(VechicleProblemModel.self, from: data)
                        self.vehicleProblems = vechicleProblemsModel
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            if let controller = Controllers.vehicleComplaint.getController() as? VehicleComplaintViewController {
                                controller.category = self.category
                                controller.subCategories = self.subCategories
                                controller.selectedSubCategory = self.selectedSubCategory
                                controller.vechicleTypes = self.vechicleTypes
                                controller.selectedVehicleType = self.selectedVehicleType
                                controller.vehicleBrands = self.vehicleBrands
                                controller.selectedVehicleBrand = self.selectedVehicleBrand
                                controller.vehicles = self.vehicles
                                controller.selectedVehicle = self.selectedVehicle
                                controller.vehicleProblems = self.vehicleProblems
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }catch {
                        print("Error: VehicleBrandsViewController getVechicles - \(error.localizedDescription)")
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
    
    @IBAction func textfieldIsEditing(_ textfield: UITextField){
        if textfield.text?.count == 0 {
            searchResults = vehicles?.response ?? []
            searchTableView.reloadData()
        }else if let searchText  = textfield.text?.lowercased() {
            searchResults = vehicles?.response?.filter({ $0.vehicleName?.lowercased().contains(searchText) ?? false }) ?? []
            searchTableView.reloadData()
        }
    }
    
    @IBAction func searchContinue() {
        hideSearchView()
    }
}

extension VehicleBrandsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchTableView {
            return 1
        }
        return 4
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
                cell.configureUI(vechicle: searchResults[indexPath.row])
                return cell
            }
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubServicesTableViewCell", for: indexPath) as? SubServicesTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category, vehicleBrand: vehicleBrands)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell {
                cell.delegate = self
                cell.configureUI(vehicles: vehicles)
                return cell
            }
        }
        else if indexPath.section == 3 {
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
extension VehicleBrandsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView {
            return 40
        }
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            let rows: Int = (((vehicleBrands?.response?.count ?? 0)/3) + ((((vehicleBrands?.response?.count ?? 0) % 3) == 0) ? 0 : 1))
            return 170 + (((tableView.frame.width - 50)/3)*CGFloat(rows))
        }else if indexPath.section == 2 {
            return CGFloat(125 + (40*(vehicles?.response?.count ?? 0)))
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            selectedVehicle = searchResults[indexPath.row]
            searchTextfield.text = searchResults[indexPath.row].vehicleName
            
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 2)) as? SearchTableViewCell {
                cell.updateText(text: searchResults[indexPath.row].vehicleName)
            }
            
            hideSearchView()
        }
    }
}


extension VehicleBrandsViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension VehicleBrandsViewController: SubServicesTableViewCellDelegate {
    func vehicleBrandTapped(vehicleBrand: VechicleBrand?) {
        if selectedVehicleBrand?.id != vehicleBrand?.id {
            selectedVehicleBrand = vehicleBrand
            getVechicles(categoryId: vehicleBrand?.categoryID, typeID: vehicleBrand?.typeID, vehicleTypeID: vehicleBrand?.vehicleTypeID, brandID: vehicleBrand?.id)
        }
    }
}


extension VehicleBrandsViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if selectedVehicleBrand == nil {
            showAlert(title: "Error", message: "Select a brand")
        }else if selectedVehicle == nil {
            showAlert(title: "Error", message: "Select a vehicle")
        }else {
            getVehicleProblems(categoryId: selectedVehicleType?.categoryID, typeID: selectedVehicleType?.typeID, vehicleTypeID: selectedVehicleType?.id)
        }
    }
}


extension VehicleBrandsViewController: SearchTableViewCellDelegate {
    func searchTapped() {
        searchView.alpha = 0
        searchView.isHidden = false
        searchTableView.reloadData()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.searchView.alpha = 1
        }
    }
    func vehicleSelected(vehicle: Vechicle?) {
        if selectedVehicle?.id != vehicle?.id {
            selectedVehicle = vehicle
        }
    }
}
