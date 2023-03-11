//
//  WoozTripViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 11/03/23.
//

import UIKit

struct TripType {
    var image: String
    var name: String
    var isSelected: Bool
}

class WoozTripViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintTypes: [ComplaintType]?
    var selectedComplaintType: ComplaintType?
    var trips: [TripType] = [TripType(image: "dropTrip", name: "Drop Trip", isSelected: true), TripType(image: "pickUpTrip", name: "Pickup Trip", isSelected: false), TripType(image: "roundTrip", name: "Round Trip", isSelected: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")

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


extension WoozTripViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
                cell.configureUI(category: category, trips: trips)
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension WoozTripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            let rows: Int = (((subCategories?.categories?.count ?? 0)/3) + ((((subCategories?.categories?.count ?? 0) % 3) == 0) ? 0 : 1))
            return 170 + (((screenWidth)/3)*CGFloat(rows))
        }
        return UITableView.automaticDimension
    }
}


extension WoozTripViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension WoozTripViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        
    }
}
