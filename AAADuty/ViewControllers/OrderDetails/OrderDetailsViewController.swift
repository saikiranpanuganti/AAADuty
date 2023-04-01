//
//  OrderDetailsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

class OrderDetailsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var orderDetails: OrderDetails?
    var orderRequest: OrderRequest?
    var allOrderDetails: (SubCategory?, SubCategoryType?, [CleaningService], Location?, String?, [ComplaintType?])?
    var requestDetailsModel: RequestDetailsModel?
    var pastOrder: PastOrder?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        tableView.register(UINib(nibName: "FlatTyreSLTableViewCell", bundle: nil), forCellReuseIdentifier: "FlatTyreSLTableViewCell")
        tableView.register(UINib(nibName: "FlatTyreDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlatTyreDetailsTableViewCell")
        tableView.register(UINib(nibName: "FlatTyreBillDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "FlatTyreBillDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderStatusTableViewCell")
        tableView.register(UINib(nibName: "FTWorkPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "FTWorkPreviewTableViewCell")
        tableView.register(UINib(nibName: "RateUsTableViewCell", bundle: nil), forCellReuseIdentifier: "RateUsTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getRequestDetails()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
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
}


extension OrderDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if requestDetailsModel != nil {
            return 7
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if indexPath.section == 0 {
            if let requestStatus = requestDetailsModel?.response?.first?.requestStatus {
                if requestStatus == "Completed" {
                    return 210
                }
            }
            return 280
        }
        return UITableView.automaticDimension
    }
}


extension OrderDetailsViewController: OrderTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension OrderDetailsViewController: RateUsTableViewCellDelegate {
    
}
