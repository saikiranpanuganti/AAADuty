//
//  PaymentModesViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit

class PaymentModesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var orderDetails: OrderDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "PaymentModeTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentModeTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
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
                cell.configureUI(amount: orderDetails?.totalAmount ?? 0)
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
        
    }
}
