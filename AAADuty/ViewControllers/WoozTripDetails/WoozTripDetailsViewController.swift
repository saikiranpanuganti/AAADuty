//
//  WoozTripDetailsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

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
        print("WoozTripDetailsViewController - bodyParams - \(bodyParams)")
        NetworkAdaptor.requestWithHeaders(urlString: Url.getWoozPrice.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()
            
            if let data = data {
                do {
                    let woozPriceModel = try JSONDecoder().decode(WoozPriceModel.self, from: data)
                    self.woozPrice = woozPriceModel.data?.first
                    print("WoozTripDetailsViewController - \(self.woozPrice)")
                    self.updateUI()
                }catch {
                    print("Error: WoozTripDetailsViewController getWoozPrice - \(error.localizedDescription)")
                }
            }
        }
    }

    func createOrderRequest() {
//        if let orderRequestParams = orderDetails?.getRequestParams() {
//            showLoader()
//
//            NetworkAdaptor.requestWithHeaders(urlString: Url.orderRequest.getUrl(), method: .post, bodyParameters: orderRequestParams) { [weak self] data, response, error in
//                guard let self = self else { return }
//                self.stopLoader()
//
//                if let data = data {
//                    do {
//                        let orderRequestModel = try JSONDecoder().decode(OrderRequestModel.self, from: data)
//                        self.orderRequest = orderRequestModel.requestData
//
//                        // Check for success and navigate only after that
////                        if self.orderRequest?.requestStatus == something
//
//                        DispatchQueue.main.async { [weak self] in
//                            guard let self = self else { return }
//                            if let controller = Controllers.paymentModes.getController() as? PaymentModesViewController {
//                                controller.orderDetails = self.orderDetails
//                                controller.orderRequest = self.orderRequest
//                                self.navigationController?.pushViewController(controller, animated: true)
//                            }
//                        }
//                    }catch {
//                        print("Error: WoozTripDetailsViewController createOrderRequest - \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
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
                cell.configureUI(amount: woozPrice?.serviceCharge ?? 0)
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
        createOrderRequest()
    }
}
