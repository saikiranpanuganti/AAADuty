//
//  CarWashDetailsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 10/03/23.
//

import UIKit

class CarWashDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintType: ComplaintType?
    var pickUpLocation: Location?
    var dropLocation: Location?
    var carWashVendors: CarWashVendorsModel?
    var selectedCarWashVendor: CarWashVendor?
    var comments: String?
    var carWashServices: [CarWashService] = []
    var selectedService: CarWashService?

    override func viewDidLoad() {
        super.viewDidLoad()

        setSelectedSubCategory()
        carWashServices = selectedCarWashVendor?.services?.filter({ $0.typeID == selectedSubCategory?.id }) ?? []
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "CarVendorTableViewCell", bundle: nil), forCellReuseIdentifier: "CarVendorTableViewCell")
        tableView.register(UINib(nibName: "LocationSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSelectionTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "CarWashServiceTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "CarWashServiceTypeTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if carWashServices.count == 0 {
            showNoVendorServicesError()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func showNoVendorServicesError() {
        self.showAlert(title: "Error", message: "No Services available for the vendor") { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }

    func setSelectedSubCategory() {
        for (index, category) in (subCategories?.categories ?? []).enumerated() {
            if category.id == selectedSubCategory?.id {
                subCategories?.categories?[index].isSelected = true
            }else {
                subCategories?.categories?[index].isSelected = false
            }
        }
    }
    
    func setSelectedService() {
        for (index, service) in carWashServices.enumerated() {
            if service.id == selectedService?.id {
                carWashServices[index].isSelected = true
            }else {
                carWashServices[index].isSelected = false
            }
        }
    }
}


extension CarWashDetailsViewController: UITableViewDataSource {
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
                cell.configureUI(title: category?.categoryTitle)
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubServicesTableViewCell", for: indexPath) as? SubServicesTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category, subCategory: subCategories, isServiceSelectable: false)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CarVendorTableViewCell", for: indexPath) as? CarVendorTableViewCell {
                cell.delegate = self
                cell.configureUI(carWashVendor: selectedCarWashVendor)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Service Location", address: pickUpLocation?.address, pickUp: true)
                
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CarWashServiceTypeTableViewCell", for: indexPath) as? CarWashServiceTypeTableViewCell {
                cell.delegate = self
                cell.configureUI(carWashServices: carWashServices)
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
extension CarWashDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            return 170 + (screenWidth - 60)/3
        }else if indexPath.section == 2 {
            return 200
        }
        return UITableView.automaticDimension
    }
}


extension CarWashDetailsViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension CarWashDetailsViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        
    }
}


extension CarWashDetailsViewController: CarVendorTableViewCellDelegate {
    func carVendorConfirmTapped(carWashVendor: CarWashVendor?) {
        
    }
}


extension CarWashDetailsViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        if selectedService != nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let controller = Controllers.vendorSlots.getController() as? VendorSlotsViewController {
                    controller.category = self.category
                    controller.subCategories = self.subCategories
                    controller.selectedSubCategory = self.selectedSubCategory
                    controller.complaintType = self.complaintType
                    controller.pickUpLocation = self.pickUpLocation
                    controller.dropLocation = self.dropLocation
                    controller.carWashVendors = self.carWashVendors
                    controller.selectedCarWashVendor = self.selectedCarWashVendor
                    controller.comments = self.comments
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }else {
            showAlert(title: "Error", message: "Please select service type")
        }
    }
}


extension CarWashDetailsViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String) {
        
    }
}


extension CarWashDetailsViewController: CarWashServiceTypeTableViewCellDelegate {
    func serviceSelected(carWashService: CarWashService) {
        selectedService = carWashService
        setSelectedService()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadSections(IndexSet(integer: 4), with: .none)
        }
    }
}
