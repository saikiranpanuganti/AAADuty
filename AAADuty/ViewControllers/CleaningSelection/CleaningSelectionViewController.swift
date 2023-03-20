//
//  CleaningSelectionViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 19/03/23.
//

import UIKit

class CleaningSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var subCategoryTypes: SubCategoryTypesModel?
    var selectedSubCategoryType: SubCategoryType?
    var cleaningServicesModel: CleaningServicesModel?
    var selectedCleaningServices: [CleaningService] = []
    var selectedLocation: Location?
    var comments: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "ServiceDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceDetailsTableViewCell")
        tableView.register(UINib(nibName: "SelectedCleaningServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedCleaningServiceTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}


extension CleaningSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return selectedCleaningServices.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                cell.configureUI(title: category?.categoryTitle)
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as? ServiceDetailsTableViewCell {
                cell.configureUI(category: category, subCategory: subCategories, subTitle: "")
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedCleaningServiceTableViewCell", for: indexPath) as? SelectedCleaningServiceTableViewCell {
                cell.configureUI(cleaningService: selectedCleaningServices[indexPath.row])
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.title = "CONTINUE"
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension CleaningSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension CleaningSelectionViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension CleaningSelectionViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if let controller = Controllers.cleaningOrderDetails.getController() as? CleaningOrderDetailsViewController {
            controller.category = category
            controller.subCategories = subCategories
            controller.selectedSubCategory = selectedSubCategory
            controller.subCategoryTypes = subCategoryTypes
            controller.selectedSubCategoryType = selectedSubCategoryType
            controller.cleaningServicesModel = cleaningServicesModel
            controller.selectedCleaningServices = selectedCleaningServices
            controller.selectedLocation = selectedLocation
            controller.comments = comments
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
