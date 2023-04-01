//
//  OrderDetailsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

class OrderDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelReasonTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentsOutlet: UITextField!
    @IBOutlet weak var cancelReasonsView: UIView!
    @IBOutlet weak var cancelBgView: UIView!
    
    var orderDetails: OrderDetails?
    var orderRequest: OrderRequest?
    var allOrderDetails: (SubCategory?, SubCategoryType?, [CleaningService], Location?, String?, [ComplaintType?])?
    var requestDetailsModel: RequestDetailsModel?
    var pastOrder: PastOrder?
    var cancelReasonsModel: CancelReasonsModel?
    var selectedCancelReason: CancelReason?
    var takeBackToHome: Bool  = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName: "FlatTyreSLTableViewCell", bundle: nil), forCellReuseIdentifier: "FlatTyreSLTableViewCell")
        tableView.register(UINib(nibName: "FlatTyreDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlatTyreDetailsTableViewCell")
        tableView.register(UINib(nibName: "FlatTyreBillDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlatTyreBillDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderStatusTableViewCell")
        tableView.register(UINib(nibName: "FTWorkPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "FTWorkPreviewTableViewCell")
        tableView.register(UINib(nibName: "RateUsTableViewCell", bundle: nil), forCellReuseIdentifier: "RateUsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        cancelReasonTableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        cancelReasonTableView.dataSource = self
        cancelReasonTableView.delegate = self
        
        getRequestDetails()
        getCancelReasons()
    }
    
    func setUpUI() {
        cancelReasonsView.layer.cornerRadius = 50
        cancelReasonsView.layer.borderWidth = 1
        cancelReasonsView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        cancelReasonsView.layer.masksToBounds = true
        
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        submitButton.layer.shadowOpacity = 1
        submitButton.layer.shadowOffset = .zero
        submitButton.layer.shadowRadius = 5
        
        cancelBgView.isHidden = true
    }
    
    
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func updateCancelReasonsUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.cancelReasonTableView.reloadData()
        }
    }
    
    func getRequestDetails() {
        if let requestId = orderRequest?.id ?? pastOrder?.id {
            showLoader()
            
            var bodyParams: [String: Any] = [:]
            bodyParams["RequestID"] = requestId //"63464cbc9a4a550009f7bc8f" //requestId
            print("getRequestDetails bodyParams - \(bodyParams)")
            NetworkAdaptor.requestWithHeaders(urlString: Url.getRequestDetailsById.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        self.requestDetailsModel = try JSONDecoder().decode(RequestDetailsModel.self, from: data)
                        self.updateUI()
                    }catch {
                        print("Error: OrderDetailsViewController getRequestDetails - \(error)")
                    }
                }
            }
        }
    }
    
    func getCancelReasons() {
        if let categoryId = orderRequest?.categoryID ?? pastOrder?.categoryID {
            showLoader()
            
            let bodyParams: [String: Any] = ["CategoryID": categoryId]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getCancelReasons.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let cancelReasonsModel = try JSONDecoder().decode(CancelReasonsModel.self, from: data)
                        self.cancelReasonsModel = cancelReasonsModel
                        self.updateCancelReasonsUI()
                    }catch {
                        print("Error: OrderDetailsViewController getCancelReasons - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func submitCancelRequest(cancelReason: CancelReason?) {
        if let cancelReason = cancelReason {
            showLoader()
            
            var bodyParams: [String: Any] = [:]
            bodyParams["RequestID"] = requestDetailsModel?.response?.first?.id ?? ""
            bodyParams["Status"] = requestDetailsModel?.response?.first?.requestStatus ?? ""
            bodyParams["CancelReason"] = cancelReason.reason ?? ""
            bodyParams["CancelComments"] = commentsOutlet.text ?? ""
            bodyParams["AssignedFranchiserID"] = requestDetailsModel?.response?.first?.assignedFranchiseID ?? ""
            
            NetworkAdaptor.requestWithHeaders(urlString: Url.cancelRequest.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader {
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                
                                if let message = json["Message"] as? String {
                                    if message == "Cancelled Sucessfully" {
                                        self.hideCancelReasonsView()
                                        self.showAlert(title: "Success", message: "Successfully cancelled the request") {
                                            self.getRequestDetails()
                                        }
                                    }else {
                                        self.showAlert(title: "Error", message: message)
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
    
    @IBAction func hideCancelReasonsView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.cancelBgView.isHidden = true
        }
    }
    
    @IBAction func submitTapped() {
        if let selectedCancelReason = selectedCancelReason {
            submitCancelRequest(cancelReason: selectedCancelReason)
        }else {
            showAlert(title: "Error", message: "Please select cancellation reason")
        }
    }
}


extension OrderDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == cancelReasonTableView {
            return cancelReasonsModel?.reasons?.count ?? 0
        }
        
        if requestDetailsModel != nil {
            return 7
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cancelReasonTableView {
            return 1
        }
        
        if section == 4 {
            return requestDetailsModel?.response?.first?.statusTracking?.count ?? 0
        }else if section == 5 {
            if (requestDetailsModel?.response?.first?.afterPics?.count ?? 0) <= 0 {
                return 0
            }
        }else if section == 6 {
            if let requestStatus = requestDetailsModel?.response?.first?.requestStatus, requestStatus == "Completed" {
                return 1
            }
            return 0
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cancelReasonTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell {
                cell.configureUI(cancelReason: cancelReasonsModel?.reasons?[indexPath.section])
                return cell
            }
        }
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell {
                cell.delegate = self
                cell.configureUI(requestDetailsModel: requestDetailsModel)
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FlatTyreSLTableViewCell", for: indexPath) as? FlatTyreSLTableViewCell {
                cell.configureUI(requestDetailsModel: requestDetailsModel)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FlatTyreDetailsTableViewCell", for: indexPath) as? FlatTyreDetailsTableViewCell {
                cell.configureUI(requestDetailsModel: requestDetailsModel)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FlatTyreBillDetailsTableViewCell", for: indexPath) as? FlatTyreBillDetailsTableViewCell {
                cell.configureUI(requestDetailsModel: requestDetailsModel)
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusTableViewCell", for: indexPath) as? OrderStatusTableViewCell {
                var hideTop = false
                var hideBottom = false
                if indexPath.row == 0 {
                    hideTop = true
                }
                if indexPath.row == (requestDetailsModel?.response?.first?.statusTracking?.count ?? 1) - 1 {
                    hideBottom = true
                }
                cell.configureUI(statusTracking: requestDetailsModel?.response?.first?.statusTracking?[indexPath.row], hideTop: hideTop, hideBottom: hideBottom)
                return cell
            }
        }else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FTWorkPreviewTableViewCell", for: indexPath) as? FTWorkPreviewTableViewCell {
                cell.configureUI(afterPics: requestDetailsModel?.response?.first?.afterPics ?? [])
                return cell
            }
        }else if indexPath.section == 6 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RateUsTableViewCell", for: indexPath) as? RateUsTableViewCell {
                cell.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
}
extension OrderDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == cancelReasonTableView {
            let text = cancelReasonsModel?.reasons?[indexPath.section].reason ?? ""
            let height = text.height(withConstrainedWidth: screenWidth - 120, font: UIFont(name: "Trebuchet MS", size: 16))
            return height + 22
        }
        
        if indexPath.section == 0 {
            if let requestStatus = requestDetailsModel?.response?.first?.requestStatus {
                if requestStatus == "Completed" || requestStatus == "cancelled" {
                    return 210
                }
            }
            return 280
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == cancelReasonTableView {
            return UIView()
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == cancelReasonTableView {
            return 15
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cancelReasonTableView {
            if selectedCancelReason?.id != cancelReasonsModel?.reasons?[indexPath.section].id {
                selectedCancelReason = cancelReasonsModel?.reasons?[indexPath.section]
                
                for index in 0..<(cancelReasonsModel?.reasons?.count ?? 0) {
                    if index == indexPath.section {
                        cancelReasonsModel?.reasons?[index].isSelected = true
                    }else {
                        cancelReasonsModel?.reasons?[index].isSelected = false
                    }
                }
                updateCancelReasonsUI()
            }
        }
    }
}


extension OrderDetailsViewController: OrderTableViewCellDelegate {
    func backButtonTapped() {
        if takeBackToHome {
            navigationController?.popToRootViewController(animated: true)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    func cancelOrderTapped() {
        updateCancelReasonsUI()
        cancelBgView.isHidden = false
    }
}


extension OrderDetailsViewController: RateUsTableViewCellDelegate {
    
}
