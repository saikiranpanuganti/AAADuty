//
//  String + Extension.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont?) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16)], context: nil)
            
        return ceil(boundingBox.height)
    }
        
    func width(withConstraintedHeight height: CGFloat, font: UIFont?) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16)], context: nil)
        
        return ceil(boundingBox.width)
    }
}
