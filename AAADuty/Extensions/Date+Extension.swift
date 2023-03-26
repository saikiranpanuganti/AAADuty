//
//  Date+Extension.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/03/23.
//

import Foundation

extension Date {
    func getDateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
