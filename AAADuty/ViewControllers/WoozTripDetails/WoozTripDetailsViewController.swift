//
//  WoozTripDetailsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit
import CoreLocation

class WoozTripDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var makePaymentView: MakePaymentView = MakePaymentView.instanceFromNib()
    var makePaymentViewTopAnchor: NSLayoutConstraint?
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var selectedComplaintType: ComplaintType?
    var selectedPickUpLocation: Location?
    var selectedDropLocation: Location?
    var selectedPeoplePickUpLocation: Location?
    var selectedDestinationLocation: Location?
    var selectedTripType: TripType?
    var selectedWaitingTime: WaitingTime?
    var woozPrice: WoozPrice?
    var kidsSelected: Bool = false
    var womenSelected: Bool = false
    var srCitizenSelected: Bool = false
    var comments: String = ""
    var orderRequest: OrderRequest?
    var tripCharge: Int {
        let waitingCharge = (((selectedWaitingTime?.waitingTime ?? 0)*(woozPrice?.waitingPeriodPrice ?? 0))/(woozPrice?.waitingPeriod ?? 1))
        return (woozPrice?.serviceCharge ?? 0) + waitingCharge
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "ServiceDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceDetailsTableViewCell")
        tableView.register(UINib(nibName: "UserTripDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTripDetailsTableViewCell")
        tableView.register(UINib(nibName: "SpaceTableViewCell", bundle: nil), forCellReuseIdentifier: "SpaceTableViewCell")
        tableView.register(UINib(nibName: "BillDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BillDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderReviewTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addPaymentView()
        getWoozPrice()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
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
        makePaymentView.configureUI(amount: woozPrice?.serviceCharge ?? 0)
        makePaymentViewTopAnchor?.constant = -screenHeight
        view.bringSubviewToFront(makePaymentView)
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getWoozPrice() {
        showLoader()
        let bodyParams: [String: Any] = ["ServiceName": selectedTripType?.name ?? ""]
        print("getWoozPrice bodyParams - \(bodyParams)")
        print("getWoozPrice Url string - \(Url.getWoozPrice.getUrl())")
        NetworkAdaptor.requestWithHeaders(urlString: Url.getWoozPrice.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()
            
            if let data = data {
                do {
                    let woozPriceModel = try JSONDecoder().decode(WoozPriceModel.self, from: data)
                    self.woozPrice = woozPriceModel.data?.first
                    
                    self.updateUI()
                }catch {
                    print("Error: WoozTripDetailsViewController getWoozPrice - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getOrderRequestParamsDropTrip(location: Location?) -> [String: Any] {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["CustomerID"] = AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName ?? ""
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["CategoryID"] = selectedComplaintType?.categoryID ?? ""
        orderRequestParams["CategoryName"] = selectedComplaintType?.categoryName ?? ""
        orderRequestParams["typeID"] = selectedComplaintType?.typeID ?? ""
        orderRequestParams["typeName"] = selectedComplaintType?.typeName ?? ""
        orderRequestParams["WooZComplaintID"] = selectedComplaintType?.id ?? ""
        orderRequestParams["WooZComplaintName"] = selectedComplaintType?.complaint ?? ""
        orderRequestParams["WooZServiceID"] = woozPrice?.id ?? ""
        orderRequestParams["WooZService"] = woozPrice?.serviceName ?? ""
        if let userLatitude = selectedPickUpLocation?.latitude, let userLongitude = selectedPickUpLocation?.longitude, let destLatitude = selectedDropLocation?.latitude, let destLongitude = selectedDropLocation?.longitude {
            let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
            let destLocation = CLLocation(latitude: destLatitude, longitude: destLongitude)
            let distance = userLocation.distance(from: destLocation)/1000
            orderRequestParams["TotalKm"] = distance
        }else {
            orderRequestParams["TotalKm"] = 0
        }
        orderRequestParams["Tax"] = woozPrice?.pgServiceTax ?? 0
        orderRequestParams["GST"] = woozPrice?.gst ?? 0
        orderRequestParams["AddTip"] = 0
        orderRequestParams["Price"] = tripCharge
        orderRequestParams["Balance"] = 0
        orderRequestParams["Note"] = comments
        orderRequestParams["WaitingPeriodTime"] = selectedWaitingTime?.waitingTime ?? 0
        var woozInstructions: [String: String] = [:]
        if kidsSelected {
            woozInstructions["People"] = "Kids"
        }
        if womenSelected {
            woozInstructions["People"] = "Senior Citizens"
        }
        if srCitizenSelected {
            woozInstructions["People"] = "Women"
        }
        orderRequestParams["WoozInstructions"] = woozInstructions
        orderRequestParams["pinCode"] = Int(selectedPickUpLocation?.postalCode ?? "0")
        orderRequestParams["SourceAddress"] = selectedPickUpLocation?.address ?? ""
        orderRequestParams["SourctLat"] = selectedPickUpLocation?.latitude ?? 0
        orderRequestParams["SourceLong"] = selectedPickUpLocation?.longitude ?? 0
        orderRequestParams["SourceLocation"] = "\(selectedPickUpLocation?.longitude ?? 0),\(selectedPickUpLocation?.latitude ?? 0)"
        orderRequestParams["DesinationAddress"] = selectedDropLocation?.address ?? ""
        orderRequestParams["DestinationLat"] = selectedDropLocation?.latitude ?? 0
        orderRequestParams["DestinationLong"] = selectedDropLocation?.longitude ?? 0
        orderRequestParams["DestinationLocation"] = "\(selectedDropLocation?.longitude ?? 0),\(selectedDropLocation?.latitude ?? 0)"
        
        return orderRequestParams
    }
    
    func getOrderRequestParamsPickUpTrip(location: Location?) -> [String: Any] {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["AddTip"] = 0
        orderRequestParams["CarDeliveryLat"] = ""
        orderRequestParams["CarDeliveryLocation"] = ""
        orderRequestParams["CarDeliveryLocationAddress"] = ""
        orderRequestParams["CarDeliveryLong"] = ""
        orderRequestParams["CarPickupLat"] = "\(selectedPeoplePickUpLocation?.latitude ?? 0)"
        orderRequestParams["CarPickupLocation"] = "\(selectedPeoplePickUpLocation?.longitude ?? 0),\(selectedPeoplePickUpLocation?.latitude ?? 0)"
        orderRequestParams["CarPickupLocationAddress"] = selectedPeoplePickUpLocation?.address ?? ""
        orderRequestParams["CarPickupLong"] = "\(selectedPeoplePickUpLocation?.longitude ?? 0)"
        orderRequestParams["CategoryID"] = selectedComplaintType?.categoryID ?? ""
        orderRequestParams["CategoryName"] = selectedComplaintType?.categoryName ?? ""
        orderRequestParams["ComplaintTypeID"] = ""
        orderRequestParams["ComplaintTypeName"] = ""
        orderRequestParams["CustomerAddress"] = location?.address ?? ""
        orderRequestParams["CustomerID"] = AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerLocation"] = "\(location?.longitude ?? 0),\(location?.latitude ?? 0)"
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName ?? ""
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["DesinationAddress"] = selectedDropLocation?.address ?? ""
        orderRequestParams["DestinationLat"] = "\(selectedDropLocation?.latitude ?? 0)"
        orderRequestParams["DestinationLocation"] = "\(selectedDropLocation?.longitude ?? 0),\(selectedDropLocation?.latitude ?? 0)"
        orderRequestParams["DestinationLong"] = "\(selectedDropLocation?.longitude ?? 0)"
        orderRequestParams["End"] = 0
        orderRequestParams["EndTime"] = ""
        orderRequestParams["GST"] = woozPrice?.gst ?? 0
        orderRequestParams["Note"] = comments
        orderRequestParams["Price"] = tripCharge
        orderRequestParams["Remarks"] = ""
        orderRequestParams["SlotId"] = ""
        orderRequestParams["SourceAddress"] = selectedPickUpLocation?.address ?? ""
        orderRequestParams["SourceLocation"] = "\(selectedPickUpLocation?.longitude ?? 0),\(selectedPickUpLocation?.latitude ?? 0)"
        orderRequestParams["SourceLong"] = selectedPickUpLocation?.longitude ?? 0
        orderRequestParams["SourctLat"] = selectedPickUpLocation?.latitude ?? 0
        
        orderRequestParams["Start"] = 0
        orderRequestParams["StartTime"] = ""
        orderRequestParams["Tax"] = woozPrice?.pgServiceTax ?? 0
        orderRequestParams["TotalSFT"] = 0
        orderRequestParams["TransactionAmount"] = ""
        orderRequestParams["TransactionDoneBy"] = ""
        orderRequestParams["TransactionID"] = ""
        orderRequestParams["TransactionMode"] = ""
        orderRequestParams["VendorID"] = ""
        orderRequestParams["VendorPhoneNumber"] = ""
        orderRequestParams["VendorSlotID"] = ""
        orderRequestParams["VenodrName"] = ""
        orderRequestParams["pinCode"] = Int(selectedPickUpLocation?.postalCode ?? "0")
        orderRequestParams["WaitingPeriodTime"] = selectedWaitingTime?.waitingTime ?? 0
        orderRequestParams["WooZComplaintID"] = selectedComplaintType?.id ?? ""
        orderRequestParams["WooZComplaintName"] = selectedComplaintType?.complaint ?? ""
        orderRequestParams["WooZService"] = woozPrice?.serviceName ?? ""
        orderRequestParams["WooZServiceID"] = woozPrice?.id ?? ""
        
        var woozInstructions: [String: String] = [:]
        if kidsSelected {
            woozInstructions["People"] = "Kids"
        }
        if womenSelected {
            woozInstructions["People"] = "Senior Citizens"
        }
        if srCitizenSelected {
            woozInstructions["People"] = "Women"
        }
        orderRequestParams["WoozInstructions"] = woozInstructions
        
        orderRequestParams["typeID"] = selectedComplaintType?.typeID ?? ""
        orderRequestParams["typeName"] = selectedComplaintType?.typeName ?? ""
        
        if let userLatitude = selectedPickUpLocation?.latitude, let userLongitude = selectedPickUpLocation?.longitude, let destLatitude = selectedDropLocation?.latitude, let destLongitude = selectedDropLocation?.longitude {
            let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
            let destLocation = CLLocation(latitude: destLatitude, longitude: destLongitude)
            let distance = userLocation.distance(from: destLocation)/1000
            orderRequestParams["Distance"] = distance
        }else {
            orderRequestParams["Distance"] = 0
        }
        
        return orderRequestParams
    }
    
    func getOrderRequestParamsRoundTrip(location: Location?) -> [String: Any] {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["CustomerID"] = AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName ?? ""
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["CategoryID"] = selectedComplaintType?.categoryID ?? ""
        orderRequestParams["CategoryName"] = selectedComplaintType?.categoryName ?? ""
        orderRequestParams["typeID"] = selectedComplaintType?.typeID ?? ""
        orderRequestParams["typeName"] = selectedComplaintType?.typeName ?? ""
        orderRequestParams["WooZComplaintID"] = selectedComplaintType?.id ?? ""
        orderRequestParams["WooZComplaintName"] = selectedComplaintType?.complaint ?? ""
        orderRequestParams["WooZServiceID"] = woozPrice?.id ?? ""
        orderRequestParams["WooZService"] = woozPrice?.serviceName ?? ""
        
        if let userLatitude = selectedPickUpLocation?.latitude, let userLongitude = selectedPickUpLocation?.longitude, let destLatitude = selectedDropLocation?.latitude, let destLongitude = selectedDropLocation?.longitude {
            let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
            let destLocation = CLLocation(latitude: destLatitude, longitude: destLongitude)
            let distance = userLocation.distance(from: destLocation)/1000
            orderRequestParams["TotalKm"] = distance
        }else {
            orderRequestParams["TotalKm"] = 0
        }
        
        orderRequestParams["Tax"] = woozPrice?.pgServiceTax ?? 0
        orderRequestParams["GST"] = woozPrice?.gst ?? 0
        orderRequestParams["AddTip"] = 0
        orderRequestParams["Price"] = tripCharge
        orderRequestParams["Balance"] = 0
        orderRequestParams["Note"] = comments
        orderRequestParams["WaitingPeriodTime"] = selectedWaitingTime?.waitingTime ?? 0
        
        var woozInstructions: [String: String] = [:]
        if kidsSelected {
            woozInstructions["People"] = "Kids"
        }
        if womenSelected {
            woozInstructions["People"] = "Senior Citizens"
        }
        if srCitizenSelected {
            woozInstructions["People"] = "Women"
        }
        orderRequestParams["WoozInstructions"] = woozInstructions
        
        orderRequestParams["pinCode"] = Int(selectedPickUpLocation?.postalCode ?? "0")
        orderRequestParams["SourceAddress"] = selectedPickUpLocation?.address ?? ""
        orderRequestParams["SourctLat"] = selectedPickUpLocation?.latitude ?? 0
        orderRequestParams["SourceLong"] = selectedPickUpLocation?.longitude ?? 0
        orderRequestParams["SourceLocation"] = "\(selectedPickUpLocation?.longitude ?? 0),\(selectedPickUpLocation?.latitude ?? 0)"
        orderRequestParams["DesinationAddress"] = selectedDropLocation?.address ?? ""
        orderRequestParams["DestinationLat"] = selectedDropLocation?.latitude ?? 0
        orderRequestParams["DestinationLong"] = selectedDropLocation?.longitude ?? 0
        orderRequestParams["DestinationLocation"] = "\(selectedDropLocation?.longitude ?? 0),\(selectedDropLocation?.latitude ?? 0)"
        orderRequestParams["CarPickupLocationAddress"] = selectedPeoplePickUpLocation?.address ?? ""
        orderRequestParams["CarPickupLat"] = selectedPeoplePickUpLocation?.latitude ?? 0
        orderRequestParams["CarPickupLong"] = selectedPeoplePickUpLocation?.longitude ?? 0
        orderRequestParams["CarPickupLocation"] = "\(selectedPeoplePickUpLocation?.longitude ?? 0),\(selectedPeoplePickUpLocation?.latitude ?? 0)"
        orderRequestParams["CarDeliveryLocationAddress"] = selectedDestinationLocation?.address ?? ""
        orderRequestParams["CarDeliveryLocation"] = "\(selectedDestinationLocation?.longitude ?? 0),\(selectedDestinationLocation?.latitude ?? 0)"
        orderRequestParams["CarDeliveryLat"] = selectedDestinationLocation?.latitude ?? 0
        orderRequestParams["CarDeliveryLong"] = selectedDestinationLocation?.longitude ?? 0
        
        return orderRequestParams
    }

    func createOrderRequest(location: Location?) {
        var bodyParams: [String: Any] = [:]
        if selectedTripType?.id == "dptp" {
            bodyParams = getOrderRequestParamsDropTrip(location: location)
        }else if selectedTripType?.id == "pptp" {
            bodyParams = getOrderRequestParamsPickUpTrip(location: location)
        }else if selectedTripType?.id == "rptp" {
            bodyParams = getOrderRequestParamsRoundTrip(location: location)
        }
        
        showLoader()
        NetworkAdaptor.requestWithHeaders(urlString: Url.orderRequest.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()

            if let data = data {
                do {
                    let orderRequestModel = try JSONDecoder().decode(OrderRequestModel.self, from: data)
                    self.orderRequest = orderRequestModel.requestData
                    
                    if orderRequestModel.message == "Data Saved Sucessfully" {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            if let controller = Controllers.paymentModes.getController() as? PaymentModesViewController {
//                                controller.orderDetails = self.orderDetails
                                controller.orderRequest = self.orderRequest
                                self.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }else {
                        let jsonError = try? JSONSerialization.jsonObject(with: data)
                        print("Error: WoozTripDetailsViewController createOrderRequest error - \(error) jsonError - \(jsonError)")
                        self.showAlert(title: "Error", message: orderRequestModel.message ?? "Error saving the order request")
                    }
                }catch {
                    let jsonError = try? JSONSerialization.jsonObject(with: data)
                    print("Error: WoozTripDetailsViewController createOrderRequest catch error - \(error) jsonError - \(jsonError)")
                }
            }
        }
    }
}


extension WoozTripDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as? ServiceDetailsTableViewCell {
                cell.configureUI(category: category, subCategory: subCategories, subTitle: "Route Summary")
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserTripDetailsTableViewCell", for: indexPath) as? UserTripDetailsTableViewCell {
                cell.configureUI(title: "Car Pick Up", description: selectedPickUpLocation?.address ?? "", imageName: "carPickUp")
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserTripDetailsTableViewCell", for: indexPath) as? UserTripDetailsTableViewCell {
                cell.configureUI(title: "People Pick Up", description: selectedPeoplePickUpLocation?.address ?? "", imageName: "peoplePickUp")
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserTripDetailsTableViewCell", for: indexPath) as? UserTripDetailsTableViewCell {
                if selectedTripType?.id == "dptp" || selectedTripType?.id == "pptp" {
                    cell.configureUI(title: "Drop Location", description: selectedDropLocation?.address ?? "", imageName: "dropLocation", hideLine: true)
                }else {
                    cell.configureUI(title: "Drop Location", description: selectedDropLocation?.address ?? "", imageName: "dropLocation", hideLine: false)
                }
                return cell
            }
        }else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserTripDetailsTableViewCell", for: indexPath) as? UserTripDetailsTableViewCell {
                cell.configureUI(title: "Destination Location", description: selectedDestinationLocation?.address ?? "", imageName: "destinationLocation", hideLine: true)
                return cell
            }
        }else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceTableViewCell", for: indexPath)
            return cell
        }else if indexPath.section == 7 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailsTableViewCell", for: indexPath) as? BillDetailsTableViewCell {
                cell.configureUI(basePrice: tripCharge, amount: tripCharge)
                return cell
            }
        }else if indexPath.section == 8 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewTableViewCell", for: indexPath) as? OrderReviewTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension WoozTripDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 3 {
            if selectedTripType?.id == "dptp" {
                return 0
            }
        }else if indexPath.section == 5 {
            if selectedTripType?.id == "dptp" || selectedTripType?.id == "pptp" {
                return 0
            }
        }
            
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension WoozTripDetailsViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension WoozTripDetailsViewController: OrderReviewTableViewCellDelegate {
    func overviewTapped() {
        
    }
    func readPolicyTapped() {
        
    }
    func makePaymentTapped() {
        showPaymentView()
    }
}


extension WoozTripDetailsViewController: MakePaymentViewDelegate {
    func navigateToPaymentModes() {
        LocationManager.shared.getLocationAndAddress { [weak self] location in
            guard let self = self else { return }
            self.createOrderRequest(location: location)
        }
    }
}
