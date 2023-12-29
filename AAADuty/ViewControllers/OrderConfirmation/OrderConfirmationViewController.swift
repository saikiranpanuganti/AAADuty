//
//  OrderConfirmationViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

class OrderConfirmationViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var makePaymentView: MakePaymentView = MakePaymentView.instanceFromNib()
    var makePaymentViewTopAnchor: NSLayoutConstraint?
    
    var orderDetails: OrderDetails?
    var orderRequest: OrderRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "TowingDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "TowingDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderAddressTableViewCell")
        tableView.register(UINib(nibName: "BillDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BillDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderReviewTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func showPaymentView() {
        if AppData.shared.isLogged {
            makePaymentView.isHidden = false
            makePaymentView.configureUI(amount: getAmount())
            makePaymentViewTopAnchor?.constant = -screenHeight
            view.bringSubviewToFront(makePaymentView)
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.view.layoutIfNeeded()
            }
        }else {
            // Show login pop up
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Login Alert", message: "Please login to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    let loginController = Controllers.login.getController()
//                    loginController.modalPresentationStyle = .overFullScreen
//                    self.present(loginController, animated: true, completion: nil)
                    self.navigationController?.pushViewController(loginController, animated: false)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getAmount() -> Int {
        var amount = 0
        if orderDetails?.category?.serviceType == .flatTyre {
            let price = ((orderDetails?.count ?? 0)*(orderDetails?.complaintType?.price ?? 0))
            amount = price //+ (orderDetails?.complaintType?.serviceCharge ?? 0) + (orderDetails?.complaintType?.pgServiceTax ?? 0)
        }else if orderDetails?.category?.serviceType == .vechicletech {
            amount = (orderDetails?.vehicleProblem?.price ?? 0) //+ (orderDetails?.vehicleProblem?.pgServiceTax ?? 0) + (orderDetails?.vehicleProblem?.gst ?? 0)
        }else if orderDetails?.category?.serviceType == .carWash {
            amount = orderDetails?.totalAmount ?? 0
        }else {
            amount = (orderDetails?.complaintType?.price ?? 0) //+ (orderDetails?.complaintType?.serviceCharge ?? 0) + (orderDetails?.complaintType?.pgServiceTax ?? 0)
        }
        return amount
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
    
    func createOrderRequest() {
        if let orderRequestParams = orderDetails?.getRequestParams() {
            showLoader()
            print("$$CW: createOrderRequest Url \(Url.orderRequest.getUrl())")
            print("$$CW: createOrderRequest Headers \(Headers.getHeaders())")
            print("$$CW: createOrderRequest bodyParameters - \(orderRequestParams)")
            NetworkAdaptor.requestWithHeaders(urlString: Url.orderRequest.getUrl(), method: .post, bodyParameters: orderRequestParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader {
                    if let data = data {
                        do {
                            let orderRequestModel = try JSONDecoder().decode(OrderRequestModel.self, from: data)
                            self.orderRequest = orderRequestModel.requestData
                            
                            if orderRequestModel.message == "Data Saved Sucessfully" {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    if let controller = Controllers.paymentModes.getController() as? PaymentModesViewController {
                                        controller.orderDetails = self.orderDetails
                                        controller.orderRequest = self.orderRequest
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }else {
                                self.showAlert(title: "Error", message: orderRequestModel.message ?? "Error saving the order request")
                            }
                        }catch {
                            print("Error: OrderConfirmationViewController createOrderRequest - \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

extension OrderConfirmationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.configureUI(title: orderDetails?.category?.categoryTitle)
                cell.delegate = self
                return cell
            }
        }else if indexPath.row == 1 {
            if orderDetails?.category?.serviceType == .towing {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TowingDetailsTableViewCell", for: indexPath) as? TowingDetailsTableViewCell {
                    cell.delegate = self
                    cell.configureUI(orderDetails: orderDetails)
                    return cell
                }
            }else if orderDetails?.category?.serviceType == .flatTyre || orderDetails?.category?.serviceType == .vechicletech {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAddressTableViewCell", for: indexPath) as? OrderAddressTableViewCell {
                    cell.delegate = self
                    if orderDetails?.category?.serviceType == .flatTyre {
                        cell.configureUI(orderDetails: orderDetails)
                    }else if orderDetails?.category?.serviceType == .vechicletech {
                        cell.configureUI(orderDetails_VT: orderDetails)
                    }
                    return cell
                }
            }else if orderDetails?.category?.serviceType == .carWash {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TowingDetailsTableViewCell", for: indexPath) as? TowingDetailsTableViewCell {
                    cell.delegate = self
                    cell.configureUI(orderDetails: orderDetails)
                    return cell
                }
            }
        }else if indexPath.row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailsTableViewCell", for: indexPath) as? BillDetailsTableViewCell {
                cell.configureUI(basePrice: orderDetails?.totalAmount ?? 0, amount: getAmount())
                return cell
            }
        }else if indexPath.row == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewTableViewCell", for: indexPath) as? OrderReviewTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension OrderConfirmationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }
        return UITableView.automaticDimension
    }
}


extension OrderConfirmationViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    func notificationsTapped() {
        let notificationsVC = Controllers.notificationsVC.getController()
        notificationsVC.modalPresentationStyle = .fullScreen
        notificationsVC.modalTransitionStyle = .crossDissolve
        self.present(notificationsVC, animated: true)
    }
}


extension OrderConfirmationViewController: OrderAddressTableViewCellDelegate {
    func editTapped() {
        
    }
}


extension OrderConfirmationViewController: OrderReviewTableViewCellDelegate {
    func overviewTapped() {
        
    }
    func readPolicyTapped() {
        
    }
    func makePaymentTapped() {
        showPaymentView()
    }
}


extension OrderConfirmationViewController: MakePaymentViewDelegate {
    func navigateToPaymentModes() {
        createOrderRequest()
    }
}

extension OrderConfirmationViewController: TowingDetailsTableViewCellDelegate {
    func towingEditTapped() {
        
    }
}
