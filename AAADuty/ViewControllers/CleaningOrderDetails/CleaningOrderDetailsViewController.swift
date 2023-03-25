//
//  CleaningOrderDetailsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 19/03/23.
//

import UIKit

class CleaningOrderDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var makePaymentView: MakePaymentView = MakePaymentView.instanceFromNib()
    var makePaymentViewTopAnchor: NSLayoutConstraint?
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var subCategoryTypes: SubCategoryTypesModel?
    var selectedSubCategoryType: SubCategoryType?
    var cleaningServicesModel: CleaningServicesModel?
    var selectedCleaningServices: [CleaningService] = []
    var selectedLocation: Location?
    var comments: String?
    var complaintTypes: [ComplaintType]?
    var selectedComplaintTypes: [ComplaintType?] = []
    var orderRequest: OrderRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "OrderDetailsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsHeaderTableViewCell")
        tableView.register(UINib(nibName: "ServiceOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceOrderTableViewCell")
        tableView.register(UINib(nibName: "SpaceTableViewCell", bundle: nil), forCellReuseIdentifier: "SpaceTableViewCell")
        tableView.register(UINib(nibName: "BillDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BillDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderReviewTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addPaymentView()
    }
    
    func addPaymentView() {
        view.addSubview(makePaymentView)
        makePaymentView.delegate = self
        
        makePaymentView.translatesAutoresizingMaskIntoConstraints = false
        makePaymentViewTopAnchor = makePaymentView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
        makePaymentViewTopAnchor?.isActive = true
        makePaymentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        makePaymentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        makePaymentView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
        makePaymentView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognised))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognised() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.makePaymentView.isHidden {
                self.makePaymentViewTopAnchor?.constant = 50
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                } completion: { bool in
                    self.makePaymentView.isHidden = true
                }
            }
        }
    }
    
    func showPaymentView() {
        makePaymentView.isHidden = false
        makePaymentView.configureUI(amount: getTotalBaseAmount())
        makePaymentViewTopAnchor?.constant = -screenHeight
        view.bringSubviewToFront(makePaymentView)
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getOrderRequestParams() -> [String: Any] {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["CustomerID"] =  AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName ?? ""
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["DesinationAddress"] = selectedLocation?.address ?? ""
        orderRequestParams["DestinationLocation"] = "\(selectedLocation?.longitude ?? 0),\(selectedLocation?.latitude ?? 0)"
        orderRequestParams["DestinationLat"] = "\(selectedLocation?.latitude ?? 0)"
        orderRequestParams["DestinationLong"] = "\(selectedLocation?.longitude ?? 0)"
        orderRequestParams["CategoryID"] = category?.id ?? ""
        orderRequestParams["CategoryName"] = category?.category ?? ""
        orderRequestParams["typeID"] = selectedCleaningServices.first?.typeID ?? ""
        orderRequestParams["typeName"] = selectedCleaningServices.first?.typeName ?? ""
        orderRequestParams["pinCode"] = Int(selectedLocation?.postalCode ?? "0")
        orderRequestParams["AddTip"] = 0
        orderRequestParams["Note"] = comments ?? ""
        
        var amount = 0
        var taxAmount = 0
        var selectedServices: [[String: Any]] = []
        
        for service in selectedCleaningServices {
            var serviceParams: [String: Any] = [:]
            serviceParams["CategoryID"] = service.categoryID ?? ""
            serviceParams["CategoryName"] = service.categoryName ?? ""
            serviceParams["typeID"] = service.typeID ?? ""
            serviceParams["typeName"] = service.typeName ?? ""
            serviceParams["Price"] = service.price ?? 0
            serviceParams["Complaint"] = service.serviceName ?? ""
            serviceParams["NoOfCount"] = "\(service.count)"
            serviceParams["isActive"] = service.isActive ?? false
            selectedServices.append(serviceParams)
            
            amount += (service.price ?? 0) //((service.price ?? 0) + (service.pgServiceTax ?? 0))
            taxAmount += (service.pgServiceTax ?? 0)
        }
        
        orderRequestParams["Services"] = selectedServices
        orderRequestParams["Price"] = amount
        orderRequestParams["Tax"] = taxAmount
        orderRequestParams["GST"] = 0
        return orderRequestParams
    }
    
    func createOrderRequest() {
        let orderRequestParams = getOrderRequestParams()
        showLoader()
        print("orderRequestParams - \(orderRequestParams)")
        NetworkAdaptor.requestWithHeaders(urlString: Url.orderRequest.getUrl(), method: .post, bodyParameters: orderRequestParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()
            
            if let data = data {
                do {
                    let orderRequestModel = try JSONDecoder().decode(OrderRequestModel.self, from: data)
                    self.orderRequest = orderRequestModel.requestData
                    print("orderRequestModel - \(orderRequestModel)")
                    if orderRequestModel.message == "Data Saved Sucessfully" {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            if let controller = Controllers.paymentModes.getController() as? PaymentModesViewController {
                                controller.allOrderDetails = (self.selectedSubCategory, self.selectedSubCategoryType, self.selectedCleaningServices, self.selectedLocation, self.comments, self.selectedComplaintTypes)
                                controller.orderRequest = self.orderRequest
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }else {
                        self.showAlert(title: "Error", message: orderRequestModel.message ?? "Error saving the order request")
                    }
                }catch {
                    print("Error: CleaningOrderDetailsViewController createOrderRequest - \(error.localizedDescription)")
                }
            }
        }
    }

    func getTotalBaseAmount() -> Int {
        var total = 0
        if selectedComplaintTypes.count > 0 {
            for complaint in selectedComplaintTypes {
                total += complaint?.price ?? 0
            }
        }else {
            for selectedCleaningService in selectedCleaningServices {
                total += ((selectedCleaningService.price ?? 0)*selectedCleaningService.count)
            }
        }
        
        return total
    }
    
//    func getTotalAmount() -> Int {
//        var total = 0
//        if selectedComplaintTypes.count > 0 {
//            for complaint in selectedComplaintTypes {
//                let charges = (complaint?.pgServiceTax ?? 0) + (complaint?.gst ?? 0) + (complaint?.serviceCharge ?? 0)
//                total += ((complaint?.price ?? 0) + charges)
//            }
//        }else {
//            for selectedCleaningService in selectedCleaningServices {
//                total += (((selectedCleaningService.price ?? 0) + (selectedCleaningService.pgServiceTax ?? 0))*selectedCleaningService.count)
//            }
//        }
//
//        return total
//    }
}


extension CleaningOrderDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if selectedComplaintTypes.count > 0 {
                return (selectedComplaintTypes.count + 1)
            }else {
                return (selectedCleaningServices.count + 1)
            }
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsHeaderTableViewCell", for: indexPath) as? OrderDetailsHeaderTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceOrderTableViewCell", for: indexPath) as? ServiceOrderTableViewCell {
                if indexPath.row == 0 {
                    cell.configureUI(location: selectedLocation)
                }else {
                    if selectedComplaintTypes.count > 0 {
                        cell.configureUI(complaintType: selectedComplaintTypes[indexPath.row - 1])
                    }else {
                        cell.configureUI(cleaningService: selectedCleaningServices[indexPath.row - 1])
                    }
                }
                
                return cell
            }
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceTableViewCell", for: indexPath)
            return cell
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailsTableViewCell", for: indexPath) as? BillDetailsTableViewCell {
                cell.configureUI(basePrice: getTotalBaseAmount(), amount: getTotalBaseAmount())
                return cell
            }
        }else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewTableViewCell", for: indexPath) as? OrderReviewTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension CleaningOrderDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension CleaningOrderDetailsViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension CleaningOrderDetailsViewController: OrderDetailsHeaderTableViewCellDelegate {
    func editTapped() {
        
    }
}


extension CleaningOrderDetailsViewController: OrderReviewTableViewCellDelegate {
    func overviewTapped() {
        
    }
    func readPolicyTapped() {
        
    }
    func makePaymentTapped() {
        showPaymentView()
    }
}


extension CleaningOrderDetailsViewController: MakePaymentViewDelegate {
    func navigateToPaymentModes() {
        createOrderRequest()
    }
}
