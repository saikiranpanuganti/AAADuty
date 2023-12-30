//
//  BookingsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import UIKit

class BookingsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurBackgroundView: UIView!
    @IBOutlet weak var blurBackgroundBcakButton: UIButton!
    
    var pastOrdersModel: PastOrdersModel?
    var hideBackButton: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        tableView.register(UINib(nibName: "BookingsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsHeaderTableViewCell")
        tableView.register(UINib(nibName: "PastOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "PastOrderTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSuccess), name: NSNotification.Name(loginSuccess), object: nil)
        
        if hideBackButton {
            blurBackgroundBcakButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AppData.shared.isLogged {
            blurBackgroundView.isHidden = true
            getPastOrders()
        }else {
            blurBackgroundView.isHidden = false
        }
    }
    
    @objc func handleLoginSuccess() {
        blurBackgroundView.isHidden = false
        getPastOrders(shouldShowLoader: false)
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func getPastOrders(shouldShowLoader: Bool = true) {
        if shouldShowLoader {
            showLoader()
        }
        
        var bodyParams: [String: Any] = [:]
        bodyParams["CustomerID"] = AppData.shared.user?.id ?? ""
        bodyParams["RequestStatus"] = "Completed"
        
        print("bodyParams - \(bodyParams)")
        
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
    
    @IBAction func backNavigationButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginTapped() {
        let loginController = Controllers.login.getController()
        self.navigationController?.pushViewController(loginController, animated: true)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0, let controller = Controllers.orderDetails.getController() as? OrderDetailsViewController {
            controller.pastOrder = pastOrdersModel?.pastorders?[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension BookingsViewController: BookingsHeaderTableViewCellDelegate {
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
