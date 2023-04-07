//
//  WoozTripViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 11/03/23.
//

import UIKit

struct TripType {
    var id: String
    var image: String
    var name: String
    var isSelected: Bool
}

class WoozTripViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintTypes: [ComplaintType]?
    var selectedComplaintType: ComplaintType?
    var trips: [TripType] = [TripType(id: "dptp", image: "dropTrip", name: "Drop Trip", isSelected: true), TripType(id: "pptp", image: "pickUpTrip", name: "Pickup Trip", isSelected: false), TripType(id: "rptp", image: "roundTrip", name: "Round Trip", isSelected: false)]
    var selectedPickUpLocation: Location?
    var selectedDropLocation: Location?
    var selectedPeoplePickUpLocation: Location?
    var selectedDestinationLocation: Location?
    var waitingTimesModel: WaitingTimesModel?
    var selectedTripType: TripType?
    var selectedWaitingTime: WaitingTime?
    var waitingSelected: Bool = false
    var hideNote: Bool = false
    var kidsSelected: Bool = false
    var womenSelected: Bool = false
    var srCitizenSelected: Bool = false
    var comments: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "LocationSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSelectionTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "WaitingTableViewCell", bundle: nil), forCellReuseIdentifier: "WaitingTableViewCell")
        tableView.register(UINib(nibName: "InstructionsTableViewCell", bundle: nil), forCellReuseIdentifier: "InstructionsTableViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        selectedTripType = trips[0]
        getWaitingTimes()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func resignTextFieldAsResponder() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 8)) as? CommentsTableViewCell {
            cell.textfieldOutlet.resignFirstResponder()
        }
    }
    
    func getWaitingTimes() {
        showLoader()
        NetworkAdaptor.requestWithHeaders(urlString: Url.waitingTimes.getUrl(), method: .get) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()
            
            if let data = data {
                do {
                    let waitingTimesModel = try JSONDecoder().decode(WaitingTimesModel.self, from: data)
                    self.waitingTimesModel = waitingTimesModel
                    self.updateUI()
                }catch {
                    print("Error: WoozTripViewController getWaitingTimes - \(error.localizedDescription)")
                }
            }
        }
    }
}


extension WoozTripViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
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
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Car Pickup Location", address: selectedPickUpLocation?.address, locationType: "cpl")
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Pick People", address: selectedPeoplePickUpLocation?.address, locationType: "ppl")
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Drop Location", address: selectedDropLocation?.address, locationType: "dpl")
                return cell
            }
        }else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingTableViewCell", for: indexPath) as? WaitingTableViewCell {
                cell.configureUI(waitingTimes: waitingTimesModel?.data)
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 6 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "Destination Location", address: selectedDestinationLocation?.address, locationType: "dtl")
                return cell
            }
        }else if indexPath.section == 7 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsTableViewCell", for: indexPath) as? InstructionsTableViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 8 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 9 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 10 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.title = "NEXT"
                cell.font = UIFont(name: "Segoe-UI-SemiBold", size: 18)
                cell.delegate = self
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
        }else if indexPath.section == 3 {
            if selectedTripType?.id != "pptp" && selectedTripType?.id != "rptp" {
                return 0
            }
        }
        else if indexPath.section == 5 {
            if waitingSelected {
                return 145
            }else {
                return 70
            }
        }else if indexPath.section == 6 {
            if selectedTripType?.id != "rptp" {
                return 0
            }
        }else if indexPath.section == 9 {
            if hideNote {
                return 0
            }
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
    func tripTypeTapped(tripType: TripType?) {
        if let tripType = tripType {
            if selectedTripType?.id != tripType.id {
                for (index, trip) in trips.enumerated() {
                    if tripType.id == trip.id {
                        trips[index].isSelected = true
                    }else {
                        trips[index].isSelected = false
                    }
                }
                
                selectedTripType = tripType
                updateUI()
            }
        }
    }
}


extension WoozTripViewController: LocationSelectionTableViewCellDelegate {
    func locationTapped(isFromPickUp: Bool, locationTypeId: String) {
        if let mapsVc = Controllers.maps.getController() as? MapsViewController {
            mapsVc.locationTypeId = locationTypeId
            mapsVc.delegate = self
            navigationController?.pushViewController(mapsVc, animated: true)
        }
    }
}


extension WoozTripViewController: MapsViewControllerDelegate {
    func selectedLocation(location: Location?, pickUp: Bool, locationTypeId: String) {
        if let location = location {
            if locationTypeId == "cpl" {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? LocationSelectionTableViewCell {
                    selectedPickUpLocation = location
                    cell.updateAddress(address: location.address)
                }
            }else if locationTypeId == "ppl" {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? LocationSelectionTableViewCell {
                    selectedPeoplePickUpLocation = location
                    cell.updateAddress(address: location.address)
                }
            }else if locationTypeId == "dpl" {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? LocationSelectionTableViewCell {
                    selectedDropLocation = location
                    cell.updateAddress(address: location.address)
                }
            }else if locationTypeId == "dtl" {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 6)) as? LocationSelectionTableViewCell {
                    selectedDestinationLocation = location
                    cell.updateAddress(address: location.address)
                }
            }
        }
    }
}


extension WoozTripViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.resignTextFieldAsResponder()
            
            if let controller = Controllers.woozTripDetails.getController() as? WoozTripDetailsViewController {
                controller.category = self.category
                controller.subCategories = self.subCategories
                controller.selectedSubCategory = self.selectedSubCategory
                controller.selectedComplaintType = self.selectedComplaintType
                controller.selectedPickUpLocation = self.selectedPickUpLocation
                controller.selectedDropLocation = self.selectedDropLocation
                controller.selectedPeoplePickUpLocation = self.selectedPeoplePickUpLocation
                controller.selectedDestinationLocation = self.selectedDestinationLocation
                controller.selectedTripType = self.selectedTripType
                if self.waitingSelected {
                    controller.selectedWaitingTime = self.selectedWaitingTime
                }
                controller.kidsSelected = self.kidsSelected
                controller.womenSelected = self.womenSelected
                controller.srCitizenSelected = self.srCitizenSelected
                controller.comments = self.comments
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}


extension WoozTripViewController: WaitingTableViewCellDelegate {
    func waitingSelected(selected: Bool) {
        waitingSelected = selected
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    func waitingTimeSelected(waitingTime: WaitingTime?) {
        selectedWaitingTime = waitingTime
    }
}


extension WoozTripViewController: NoteTableViewCellDelegate {
    func noteCloseTapped() {
        hideNote = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}


extension WoozTripViewController: InstructionsTableViewCellDelegate {
    func kidsTapped(selected: Bool) {
        kidsSelected = selected
    }
    func womenTapped(selected: Bool) {
        womenSelected = selected
    }
    func srCitizenTapped(selected: Bool) {
        srCitizenSelected = selected
    }
}


extension WoozTripViewController: CommentsTableViewCellDelegate {
    func commentsEntered(comments: String?) {
        self.comments = comments ?? ""
    }
}
