//
//  BookingsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import UIKit

class BookingsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var pastOrdersModel: PastOrdersModel?
    var hideBackButton: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        tableView.register(UINib(nibName: "BookingsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsHeaderTableViewCell")
        tableView.register(UINib(nibName: "PastOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "PastOrderTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPastOrders()
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func getPastOrders() {
        showLoader()
        
        var bodyParams: [String: Any] = [:]
        bodyParams["CustomerID"] = AppData.shared.user?.id ?? ""
        bodyParams["RequestStatus"] = "Completed"
        
        NetworkAdaptor.requestWithHeaders(urlString: Url.getPastOrders.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()
            
            if let data = data {
                do { 
                    self.pastOrdersModel = try JSONDecoder().decode(PastOrdersModel.self, from: data)
                    self.updateUI()
                }catch {
                    print("Error: BookingsViewController getPastOrders - \(error)")
                }
            }
        }
    }
}

extension BookingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return pastOrdersModel?.pastorders?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsHeaderTableViewCell", for: indexPath) as? BookingsHeaderTableViewCell {
                cell.delegate = self
                cell.configureUI(hideBackButton: hideBackButton)
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PastOrderTableViewCell", for: indexPath) as? PastOrderTableViewCell {
                cell.configureUI(pastOrder: pastOrdersModel?.pastorders?[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension BookingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension BookingsViewController: BookingsHeaderTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
