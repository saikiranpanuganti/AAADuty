//
//  OrderConfirmationViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

struct OrderDetails {
    var category: Category?
    var totalAmount: Int?
    var address: String?
    var serviceDetails: String?
}

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var orderDetails: OrderDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "OrderAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderAddressTableViewCell")
        tableView.register(UINib(nibName: "BillDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "BillDetailsTableViewCell")
        tableView.register(UINib(nibName: "OrderReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderReviewTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
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
                cell.delegate = self
                return cell
            }
        }else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAddressTableViewCell", for: indexPath) as? OrderAddressTableViewCell {
                cell.delegate = self
                cell.configureUI(orderDetails: orderDetails)
                return cell
            }
        }else if indexPath.row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BillDetailsTableViewCell", for: indexPath) as? BillDetailsTableViewCell {
                cell.configureUI(amount: orderDetails?.totalAmount ?? 0)
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
        
    }
}
