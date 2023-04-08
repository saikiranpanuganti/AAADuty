//
//  DatesTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/04/23.
//

import UIKit

class DatesTableViewCell: UITableViewCell {
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var todaysMonth: UILabel!
    @IBOutlet weak var yesterdayDate: UILabel!
    @IBOutlet weak var yesterdayMonth: UILabel!
    @IBOutlet weak var nextDayDate: UILabel!
    @IBOutlet weak var nextDayMonth: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        todaysDate.text = Date().getDateString(format: "dd")
        todaysMonth.text = Date().getDateString(format: "MMM")
        
        if let yesterdaysDt = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            yesterdayDate.text = yesterdaysDt.getDateString(format: "dd")
            yesterdayMonth.text = yesterdaysDt.getDateString(format: "MMM")
        }
        
        if let tomorrowsDt = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            nextDayDate.text = tomorrowsDt.getDateString(format: "dd")
            nextDayMonth.text = tomorrowsDt.getDateString(format: "MMM")
        }
    }

    func configureUI(date: String?) {
        if let date = date {
            if let todaysDt = date.toDate(.isoDateTimeMilliSec) {
                todaysDate.text = todaysDt.getDateString(format: "dd")
                todaysMonth.text = todaysDt.getDateString(format: "MMM")
                
                if let yesterdaysDt = Calendar.current.date(byAdding: .day, value: -1, to: todaysDt) {
                    yesterdayDate.text = yesterdaysDt.getDateString(format: "dd")
                    yesterdayMonth.text = yesterdaysDt.getDateString(format: "MMM")
                }
                
                if let tomorrowsDt = Calendar.current.date(byAdding: .day, value: 1, to: todaysDt) {
                    nextDayDate.text = tomorrowsDt.getDateString(format: "dd")
                    nextDayMonth.text = tomorrowsDt.getDateString(format: "MMM")
                }
            }
        }
    }
    
}
