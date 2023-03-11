//
//  CarWashVendorsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 10/03/23.
//

import UIKit

class CarWashVendorsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintType: ComplaintType?
    var pickUpLocation: Location?
    var carWashVendors: CarWashVendorsModel?
    var selectedCarWashVendor: CarWashVendor?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "ServiceDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceDetailsTableViewCell")
        tableView.register(UINib(nibName: "CarVendorTableViewCell", bundle: nil), forCellReuseIdentifier: "CarVendorTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
}


extension CarWashVendorsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return carWashVendors?.data?.count ?? 0
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
                cell.configureUI(category: category, subCategory: subCategories, subTitle: "Select Vendor")
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CarVendorTableViewCell", for: indexPath) as? CarVendorTableViewCell {
                cell.delegate = self
                cell.configureUI(carWashVendor: carWashVendors?.data?[indexPath.row])
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension CarWashVendorsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 2 {
            return 200
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            for index in 0..<(carWashVendors?.data ?? []).count {
                if index == indexPath.row {
                    carWashVendors?.data?[index].isSelected = true
                    selectedCarWashVendor = carWashVendors?.data?[index]
                }else {
                    carWashVendors?.data?[index].isSelected = false
                }
            }
            
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
    }
}


extension CarWashVendorsViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension CarWashVendorsViewController: CarVendorTableViewCellDelegate {
    func carVendorConfirmTapped(carWashVendor: CarWashVendor?) {
        for (index, vendor) in (carWashVendors?.data ?? []).enumerated() {
            if vendor.id == carWashVendor?.id {
                carWashVendors?.data?[index].isSelected = true
                selectedCarWashVendor = carWashVendors?.data?[index]
            }else {
                carWashVendors?.data?[index].isSelected = false
            }
        }
        tableView.reloadSections(IndexSet(integer: 2), with: .none)
        
        if let controller = Controllers.carWashDetails.getController() as? CarWashDetailsViewController {
            controller.category = self.category
            controller.subCategories = self.subCategories
            controller.selectedSubCategory = self.selectedSubCategory
            controller.complaintType = self.complaintType
            controller.pickUpLocation = self.pickUpLocation
            controller.carWashVendors = self.carWashVendors
            controller.selectedCarWashVendor = self.selectedCarWashVendor
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension CarWashVendorsViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if let selectedCarWashVendor = selectedCarWashVendor {
            carVendorConfirmTapped(carWashVendor: selectedCarWashVendor)
        }else {
            showAlert(title: "Error", message: "Select a Vendor")
        }
    }
}
