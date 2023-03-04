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
    var address: String? = ""
    var serviceDetails: String?
    var pickUpAddress: String? = ""
    var dropAddress: String? = ""
}

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var makePaymentView: MakePaymentView = MakePaymentView.instanceFromNib()
    var makePaymentViewTopAnchor: NSLayoutConstraint?
    
    var orderDetails: OrderDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

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
//        makePaymentView.heightAnchor.constraint(equalToConstant: 95+((screenWidth-110)*2)/5).isActive = true
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
        makePaymentView.isHidden = false
        makePaymentView.configureUI(amount: orderDetails?.totalAmount ?? 0)
        makePaymentViewTopAnchor?.constant = -screenHeight
        view.bringSubviewToFront(makePaymentView)
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }
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
            if orderDetails?.category?.serviceType == .towing {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TowingDetailsTableViewCell", for: indexPath) as? TowingDetailsTableViewCell {
                    cell.delegate = self
                    cell.configureUI(orderDetails: orderDetails)
                    return cell
                }
            }else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderAddressTableViewCell", for: indexPath) as? OrderAddressTableViewCell {
                    cell.delegate = self
                    cell.configureUI(orderDetails: orderDetails)
                    return cell
                }
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
        showPaymentView()
    }
}


extension OrderConfirmationViewController: MakePaymentViewDelegate {
    func navigateToPaymentModes() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = Controllers.paymentModes.getController() as? PaymentModesViewController {
                controller.orderDetails = self.orderDetails
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

extension OrderConfirmationViewController: TowingDetailsTableViewCellDelegate {
    func towingEditTapped() {
        
    }
}
