//
//  CleaningViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

class CleaningViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var subCategoryTypes: SubCategoryTypesModel?
    var selectedSubCategoryType: SubCategoryType?
    var selectedLocation: Location?

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
    
    func setSelectedSubCategoryType(subCategory: SubCategory?) {
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
    
    func getSubCategoryTypes(categoryId: String?, typeID: String?) {
        if let categoryId = categoryId, let typeID = typeID {
            showLoader()
            
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "TypeID": typeID]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getSubCategoryTypes.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let subCategoryTypes = try JSONDecoder().decode(SubCategoryTypesModel.self, from: data)
                        self.subCategoryTypes = subCategoryTypes
                        self.updateUI()
                    }catch {
                        print("Error: CleaningViewController getSubCategoryTypes - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


extension CleaningViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
                cell.configureUI(subCategoryTypes: subCategoryTypes?.response, title: "Select Service Type")
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
extension CleaningViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            return 170 + (screenWidth - 60)/3
        }else if indexPath.section == 2 {
            if subCategoryTypes?.response?.count ?? 0 == 0 {
                return 0
            }else {
                let rows: Int = (((subCategoryTypes?.response?.count ?? 0)/3) + ((((subCategoryTypes?.response?.count ?? 0) % 3) == 0) ? 0 : 1))
                return CGFloat(50 + rows*130)
            }
        }
        return UITableView.automaticDimension
    }
}


extension CleaningViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension CleaningViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        if selectedSubCategory?.id != subCategory?.id {
            selectedSubCategory = subCategory
            setSelectedSubCategoryType(subCategory: subCategory)
            selectedSubCategoryType = nil
            getSubCategoryTypes(categoryId: subCategory?.categoryID, typeID: subCategory?.id)
        }
    }
}


extension CleaningViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String) {
        if let mapsVc = Controllers.maps.getController() as? MapsViewController {
            mapsVc.pickUp = isFromPickUp
            mapsVc.delegate = self
            navigationController?.pushViewController(mapsVc, animated: true)
        }
    }
}


extension CleaningViewController: MapsViewControllerDelegate {
    func selectedLocation(location: Location?, pickUp: Bool, locationTypeId: String) {
        if let location = location {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? LocationSelectionTableViewCell {
                selectedLocation = location
                cell.updateAddress(address: location.address)
            }
        }
    }
}


extension CleaningViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        
    }
}


extension CleaningViewController: ServiceTypesTableViewCellDelegate {
    func subCategoryTypeTapped(subCategoryType: SubCategoryType?) {
        if selectedSubCategoryType?.id != subCategoryType?.id {
            selectedSubCategoryType = subCategoryType
        }
    }
}
