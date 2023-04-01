//
//  OrderStatusTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 27/03/23.
//

import UIKit

class OrderStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
    }
    
    func setUpUI() {
        circleView.layer.cornerRadius = 10
        circleView.layer.masksToBounds = true
    }
    
    func configureUI(statusTracking: StatusTracking?, hideTop: Bool, hideBottom: Bool) {
        statusLabel.text = statusTracking?.currentStatus
        
        if hideTop {
            topLine.isHidden = true
            dateTimeLabel.text = statusTracking?.dateTime?.toDate(.isoDateTimeMilliSec)?.getDateString(format: "dd MMM yyyy \n h:mm a")
        }else {
            topLine.isHidden = false
            dateTimeLabel.text = statusTracking?.dateTime?.toDate(.isoDateTimeMilliSec)?.getDateString(format: "h:mm a")
        }
        
        if hideBottom {
            bottomLine.isHidden = true
        }else {
            bottomLine.isHidden = false
        }
        
        if statusTracking?.isActive ?? false {
            circleView.backgroundColor = UIColor(named: "navigationBarColor")
            statusLabel.textColor = UIColor(named: "navigationBarColor")
            dateTimeLabel.textColor = UIColor.black
        }else {
            circleView.backgroundColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
            statusLabel.textColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
            dateTimeLabel.textColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
        }
    }
}
