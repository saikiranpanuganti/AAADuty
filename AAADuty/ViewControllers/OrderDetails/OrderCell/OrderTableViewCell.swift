//
//  OrderTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit
import SDWebImage

protocol OrderTableViewCellDelegate: AnyObject {
    func backButtonTapped()
}

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var trackDetailsButton: UIButton!
    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    
    weak var delegate: OrderTableViewCellDelegate?
    var requestDetailsModel: RequestDetailsModel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
    }
    
    func setUpUI() {
//        roundView.layer.cornerRadius = 40
//        roundView.layer.masksToBounds = true
//        roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        backButton.setImage(UIImage(named: "leftArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = UIColor(named: "navigationBarColor")
        
        trackDetailsButton.layer.cornerRadius = 24
        trackDetailsButton.layer.masksToBounds = true
        
        cancelButton.layer.cornerRadius = 24
        cancelButton.layer.masksToBounds = true
    }
    
    func configureUI(orderRequest: OrderRequest?) {
        categoryName.text = orderRequest?.categoryName
    }
    
    func configureUI(requestDetailsModel: RequestDetailsModel?) {
        categoryName.text = requestDetailsModel?.response?.first?.categoryName
        categoryImageView.sd_setImage(with: URL(string: requestDetailsModel?.response?.first?.requestImageURL ?? ""))
        orderId.text = requestDetailsModel?.response?.first?.orderID
        currentStatus.text = requestDetailsModel?.response?.first?.requestStatus
        
        if let requestStatus = requestDetailsModel?.response?.first?.requestStatus {
            if requestStatus == "Completed" {
                buttonsView.isHidden = true
//                trackDetailsButton.isHidden = true
//                cancelButton.isHidden = true
            }else if requestStatus == "Pending" {
                trackDetailsButton.isHidden = true
                cancelButton.isHidden = false
            }else if requestStatus == "cancelled" {
                trackDetailsButton.isHidden = true
                cancelButton.isHidden = false
                cancelButton.setTitle("Cancelled", for: .normal)
            }else {
                trackDetailsButton.isHidden = false
                cancelButton.isHidden = true
            }
        }else {
            buttonsView.isHidden = true
            trackDetailsButton.isHidden = true
            cancelButton.isHidden = true
        }
    }
    
    @IBAction func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    @IBAction func trackDetailsTapped() {
        
    }
    
    @IBAction func cancelOrderTapped() {
        
    }
}
