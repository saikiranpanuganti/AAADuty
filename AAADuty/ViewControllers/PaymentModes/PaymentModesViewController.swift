//
//  PaymentModesViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit
import Razorpay

class PaymentModesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var orderDetails: OrderDetails?
    var orderRequest: OrderRequest?
    var allOrderDetails: (SubCategory?, SubCategoryType?, [CleaningService], Location?, String?, [ComplaintType?])?
    var razorPayTestKey = "rzp_test_Dwua9vi5c5V4jd"
    var razorPayProdKey = "rzp_live_gMw018BnT0g575"//"ywMSedW1UV8UkOdpGhXepfkU"
    var paymentOrderId: String = ""
    
    var razorpay: RazorpayCheckout!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "PaymentModeTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentModeTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Update key as well as pass order if for prod set up
        razorpay = RazorpayCheckout.initWithKey(razorPayProdKey, andDelegateWithData: self)
    }
    
    func showPaymentForm() {
        let options: [String:Any] = [
            "description": "purchase description",
            "order_id": paymentOrderId,
            "image": "https://source.unsplash.com/user/c_v_r/800x800",
            "name": "Aaaduty",
            "prefill": ["contact": "7799333467", "email": "vamci@aaaduty.com"],
            "theme": ["color": "#FF0000"],
            "config": ["display": ["hide": [["method": "card"], ["method": "wallet"], ["method": "netbanking"], ["method": "paylater"], ["method": "emi"]]]]
        ]
        print("$$options - \(options)")
        self.razorpay.open(options)
    }
    
    func createPaymentOrder() {
        var bodyParams: [String: Any] = [:]
        bodyParams["amount"] = (orderRequest?.totalAmount ?? 0)*100
        bodyParams["RequestID"] = orderRequest?.id ?? ""
        bodyParams["CategoryName"] = orderRequest?.categoryName ?? ""
        bodyParams["LiveMode"] = true
        
        showLoader()
        print("$$Order: Url \(Url.createPaymentOrder.getUrl())")
        print("$$Order: bodyParams \(bodyParams)")
        
        NetworkAdaptor.requestWithHeaders(urlString: Url.createPaymentOrder.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader {
                if let data = data {
                    do {
                        let paymentOrder = try JSONDecoder().decode(PaymentOrderModel.self, from: data)
                        print("paymentOrder: \(paymentOrder.data?.id), amount - \(paymentOrder.data?.amount), \(self.orderRequest?.totalAmount)")
                        
                        if let orderId = paymentOrder.data?.id, orderId != "" {
                            self.paymentOrderId = orderId
                            self.showPaymentForm()
                        }else {
                            self.showAlert(title: "Error", message: "Something went wrong")
                        }
                    }catch {
                        print("Error: CancelRequestViewController getCancelReasons - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func savePaymentTransaction(payment_id: String) {
        var bodyParams: [String: Any] = [:]
        bodyParams["CustomerID"] = orderRequest?.customerID ?? ""
        bodyParams["RequestID"] = orderRequest?.id ?? ""
        bodyParams["CategoryName"] = orderRequest?.categoryName ?? ""
        bodyParams["TransactionAmount"] = orderRequest?.totalAmount ?? 0
        bodyParams["TransactionDoneBy"] = orderRequest?.customerName ?? ""
        bodyParams["TransactionID"] = payment_id
        bodyParams["TransactionMode"] = "Online"
        bodyParams["Remarks"] = orderRequest?.note ?? ""
        bodyParams["AddTip"] = 0
        bodyParams["AssignedFranchiseId"] = orderRequest?.assignedFranchiseID ?? ""
        
        showLoader()
        NetworkAdaptor.requestWithHeaders(urlString: Url.saveTransaction.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let message = json["Message"] as? String, message == "Data Saved Sucessfully" {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    if let controller = Controllers.requestAccepted.getController() as? RequestAcceptedViewController {
                                        controller.orderRequest = self.orderRequest
                                        controller.orderDetails = self.orderDetails
                                        controller.allOrderDetails = self.allOrderDetails
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                    }catch {
                        print("Error: CancelRequestViewController getCancelReasons - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


extension PaymentModesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                cell.configureUI(title: "PAYMENT METHOD")
                return cell
            }
        }else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeTableViewCell", for: indexPath) as? PaymentModeTableViewCell {
                cell.configureUI(amount: orderRequest?.totalAmount ?? 0)
                return cell
            }
        }else if indexPath.row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension PaymentModesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }
        return UITableView.automaticDimension
    }
}


extension PaymentModesViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension PaymentModesViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        createPaymentOrder()
    }
}


extension PaymentModesViewController: RazorpayPaymentCompletionProtocolWithData {
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", response ?? [:], code)
        showAlert(title: "Alert", message: str)
    }

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id, "response: ", response)
        savePaymentTransaction(payment_id: payment_id)
    }
}
