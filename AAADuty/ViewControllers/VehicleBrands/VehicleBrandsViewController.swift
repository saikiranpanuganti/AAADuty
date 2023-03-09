//
//  VehicleBrandsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

class VehicleBrandsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    
    var vechicleTypes: VechicleTypeModel?
    var selectedVehicleType: VechicleType?
    
    var vehicleBrands: VechicleBrandsModel?
    var selectedVehicleBrand: VechicleBrand?
    
    var vehicles: VechiclesModel?
    var selectedVehicle: Vechicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
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
                        self.updateSearchSection()
                    }catch {
                        print("Error: VehicleBrandsViewController getVechicles - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension VehicleBrandsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            let rows: Int = (((vehicleBrands?.response?.count ?? 0)/3) + ((((vehicleBrands?.response?.count ?? 0) % 3) == 0) ? 0 : 1))
            return 170 + (((tableView.frame.width - 50)/3)*CGFloat(rows))
        }else if indexPath.section == 2 {
            return CGFloat(125 + (35*(vehicles?.response?.count ?? 0)))
        }
        return UITableView.automaticDimension
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
        
    }
}


extension VehicleBrandsViewController: SearchTableViewCellDelegate {
    func searchTapped() {
        
    }
    func vehicleSelected(vehicle: Vechicle?) {
        if selectedVehicle?.id != vehicle?.id {
            selectedVehicle = vehicle
        }
    }
}
