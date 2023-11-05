//
//  VendorSlotsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/04/23.
//

import UIKit

class VendorSlotsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintType: ComplaintType?
    var pickUpLocation: Location?
    var dropLocation: Location?
    var carWashVendors: CarWashVendorsModel?
    var selectedCarWashVendor: CarWashVendor?
    var vendorSlotsModel: VendorSlotsModel?
    var selectedSlot: Slot?
    var comments: String?
    var carWashServices: [CarWashService] = []
    var selectedService: CarWashService?
    var hideNote: Bool = false
    var amount: Int {
        return Int(selectedService?.price ?? "0") ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "ServiceDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceDetailsTableViewCell")
        tableView.register(UINib(nibName: "DatesTableViewCell", bundle: nil), forCellReuseIdentifier: "DatesTableViewCell")
        tableView.register(UINib(nibName: "SlotsTableViewCell", bundle: nil), forCellReuseIdentifier: "SlotsTableViewCell")
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getVendorSlots()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func showNoVendorSlotsError() {
        self.showAlert(title: "Error", message: "No Slots available") { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func navigateToOrderConfirmationVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = Controllers.orderConfirmation.getController() as? OrderConfirmationViewController {
                LocationManager.shared.getLocationAndAddress { location in
                    controller.orderDetails = OrderDetails(category: self.category, totalAmount: self.amount, pickUpAddress: self.pickUpLocation, dropAddress: self.dropLocation, complaintType: self.complaintType, userAddress: location, count: 0, comments: self.comments, selectedService: self.selectedService, carWashVendor: self.selectedCarWashVendor, slot: self.selectedSlot)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func vendorSlotSelected(slot: Slot?) {
        if let id = slot?.id {
            for index in 0..<(vendorSlotsModel?.avialbleVendorslots?[0].vendorSlots?[0].slots?.count ?? 0) {
                if vendorSlotsModel?.avialbleVendorslots?[0].vendorSlots?[0].slots?[index].id == id {
                    print("selected indexes - \(index)")
                    vendorSlotsModel?.avialbleVendorslots?[0].vendorSlots?[0].slots?[index].isSelected = true
                }else {
                    vendorSlotsModel?.avialbleVendorslots?[0].vendorSlots?[0].slots?[index].isSelected = false
                }
            }
        }
    }
    
    func getVendorSlots() {
        if let vendorId = selectedCarWashVendor?.id {
            showLoader()
            
            let bodyParams: [String: Any] = ["VendorID": vendorId]
            NetworkAdaptor.requestWithHeaders(urlString: Url.vendorSlots.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let vendorSlotsModel = try JSONDecoder().decode(VendorSlotsModel.self, from: data)
                        self.vendorSlotsModel = vendorSlotsModel
                        if vendorSlotsModel.avialbleVendorslots?.first?.vendorSlots?.first?.slots?.count ?? 0 > 0 {
                            self.updateUI()
                        }else {
                            self.showNoVendorSlotsError()
                        }
                    }catch {
                        print("Error: CleaningViewController getCleaningServices - \(error.localizedDescription)")
                        self.showNoVendorSlotsError()
                    }
                }else {
                    self.showNoVendorSlotsError()
                }
            }
        }else {
            showNoVendorSlotsError()
        }
    }
}


extension VendorSlotsViewController: UITableViewDataSource {
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as? ServiceDetailsTableViewCell {
                cell.configureUI(category: category, subCategory: subCategories, subTitle: "Select Slots")
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DatesTableViewCell", for: indexPath) as? DatesTableViewCell {
                cell.configureUI(date: vendorSlotsModel?.avialbleVendorslots?.first?.vendorSlots?.first?.date)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SlotsTableViewCell", for: indexPath) as? SlotsTableViewCell {
                cell.configureUI(slots: vendorSlotsModel?.avialbleVendorslots?.first?.vendorSlots?.first?.slots)
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell {
                cell.configureUI(note: "NOTE : Our Rider will pick your Car with safety Tips")
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
extension VendorSlotsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 2 {
            return 131
        }else if indexPath.section == 3 {
            if let slotsCount = vendorSlotsModel?.avialbleVendorslots?.first?.vendorSlots?.first?.slots?.count {
                let rows: Int = (slotsCount/3) + (((slotsCount % 3) == 0) ? 0 : 1)
                return ((36 + 22)*CGFloat(rows)) + 40
            }
            return 0
        }else if indexPath.section == 4 {
            if hideNote {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
}


extension VendorSlotsViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension VendorSlotsViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        navigateToOrderConfirmationVC()
    }
}


extension VendorSlotsViewController: NoteTableViewCellDelegate {
    func noteCloseTapped() {
        hideNote = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}


extension VendorSlotsViewController: SlotsTableViewCellDelegate {
    func slotSelected(slot: Slot) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.selectedSlot = slot
            self.vendorSlotSelected(slot: slot)
            self.tableView.reloadSections(IndexSet(integer: 3), with: .none)
        }
    }
}
