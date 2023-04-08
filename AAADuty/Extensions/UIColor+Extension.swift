//
//  UIColor+Extension.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

extension UIColor {
    func getServiceColor(index: Int) -> UIColor {
        switch index%5 {
        case 0: return UIColor(red: 35/255, green: 200/255, blue: 1, alpha: 1)
        case 1: return UIColor(red: 254/255, green: 153/255, blue: 109/255, alpha: 1)
        case 2: return UIColor(red: 84/255, green: 224/255, blue: 187/255, alpha: 1)
        case 3: return UIColor(red: 182/255, green: 94/255, blue: 254/255, alpha: 1)
        case 4: return UIColor(red: 112/255, green: 35/255, blue: 154/255, alpha: 1)
        default: return UIColor(red: 254/255, green: 153/255, blue: 109/255, alpha: 1)
        }
    }
}
