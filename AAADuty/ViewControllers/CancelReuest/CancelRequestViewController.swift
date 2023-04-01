//
//  CancelRequestViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import UIKit
import GoogleMaps
import GooglePlaces

class CancelRequestViewController: BaseViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var cancelReasonsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsOutlet: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var orderDetails: OrderDetails?
    var orderRequest: OrderRequest?
    var allOrderDetails: (SubCategory?, SubCategoryType?, [CleaningService], Location?, String?, [ComplaintType?])?
    var cancelReasonsModel: CancelReasonsModel?
    var selectedCancelReason: CancelReason?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationButton.setImage(UIImage(named: "bellIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.tintColor = UIColor.white
        
        cancelReasonsView.layer.cornerRadius = 50
        cancelReasonsView.layer.borderWidth = 1
        cancelReasonsView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        cancelReasonsView.layer.masksToBounds = true
        
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        submitButton.layer.shadowOpacity = 1
        submitButton.layer.shadowOffset = .zero
        submitButton.layer.shadowRadius = 5
        
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        if let latitude = orderRequest?.destinationLocation?.coordinates?[1], let longitude = orderRequest?.destinationLocation?.coordinates?[0] {
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.clear()
            mapView.camera = GMSCameraPosition(target: coordinates, zoom: 15, bearing: 0, viewingAngle: 0)
            
            let destinationMarker = GMSMarker(position: coordinates)
            destinationMarker.map = mapView
        }
        
        getCancelReasons()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getCancelReasons() {
        if let categoryId = orderRequest?.categoryID {
            showLoader()
            
            let bodyParams: [String: Any] = ["CategoryID": categoryId]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getCancelReasons.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let cancelReasonsModel = try JSONDecoder().decode(CancelReasonsModel.self, from: data)
                        self.cancelReasonsModel = cancelReasonsModel
                        self.updateUI()
                    }catch {
                        print("Error: CancelRequestViewController getCancelReasons - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func submitCancelRequest(cancelReason: CancelReason?) {
        if let cancelReason = cancelReason {
            showLoader()
            
            var bodyParams: [String: Any] = [:]
            bodyParams["RequestID"] = orderRequest?.id ?? ""
            bodyParams["Status"] = orderRequest?.requestStatus ?? ""
            bodyParams["CancelReason"] = cancelReason.reason ?? ""
            bodyParams["CancelComments"] = commentsOutlet.text ?? ""
            bodyParams["AssignedFranchiserID"] = orderRequest?.assignedFranchiseID ?? ""
            
            NetworkAdaptor.requestWithHeaders(urlString: Url.cancelRequest.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader {
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                
                                if let message = json["Message"] as? String {
                                    if message == "Cancelled Sucessfully" {
                                        self.showAlert(title: "Success", message: "Successfully cancelled the request") {
                                            self.popToRootVC()
                                        }
                                    }else {
                                        self.showAlert(title: "Success", message: message)
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
    
    @IBAction func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationsTapped() {
        
    }
    
    @IBAction func submitTapped() {
        if let selectedCancelReason = selectedCancelReason {
            submitCancelRequest(cancelReason: selectedCancelReason)
        }else {
            showAlert(title: "Error", message: "Please select cancellation reason")
        }
    }
}


extension CancelRequestViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cancelReasonsModel?.reasons?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell {
            cell.configureUI(cancelReason: cancelReasonsModel?.reasons?[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
}
extension CancelRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = cancelReasonsModel?.reasons?[indexPath.section].reason ?? ""
        let height = text.height(withConstrainedWidth: screenWidth - 120, font: UIFont(name: "Trebuchet MS", size: 16))
        return height + 22
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCancelReason?.id != cancelReasonsModel?.reasons?[indexPath.section].id {
            selectedCancelReason = cancelReasonsModel?.reasons?[indexPath.section]
            
            for index in 0..<(cancelReasonsModel?.reasons?.count ?? 0) {
                if index == indexPath.section {
                    cancelReasonsModel?.reasons?[index].isSelected = true
                }else {
                    cancelReasonsModel?.reasons?[index].isSelected = false
                }
            }
            updateUI()
        }
    }
}
