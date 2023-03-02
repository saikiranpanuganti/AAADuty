//
//  AAALabel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

enum AAAFontWeight: Int {
    case light = 0
    case regular = 1
    case medium = 2
    case semibold = 3
    case bold = 4
}

enum AAAFontFamily {
    case poppins
    case sogue
}

@IBDesignable class AAALabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var fontWeight: Int = 1 {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var isPoppinsFont: Bool = false {
        didSet {
            setFont()
        }
    }
    
    func setFont() {
        switch AAAFontWeight(rawValue: fontWeight) {
        case .light:
            if isPoppinsFont {
                self.font = UIFont(name: "Poppins-Light", size: fontSize)
            }else {
                self.font = UIFont(name: "Segoe-UI", size: fontSize)
            }
        case .medium:
            if isPoppinsFont {
                self.font = UIFont(name: "Poppins-Medium", size: fontSize)
            }else {
                self.font = UIFont(name: "Segoe-UI", size: fontSize)
            }
        case .semibold:
            if isPoppinsFont {
                self.font = UIFont(name: "Poppins-SemiBold", size: fontSize)
            }else {
                self.font = UIFont(name: "Segoe-UI-Bold", size: fontSize)
            }
        case .bold:
            if isPoppinsFont {
                self.font = UIFont(name: "Poppins-Bold", size: fontSize)
            }else {
                self.font = UIFont(name: "Segoe-UI-Bold", size: fontSize)
            }
        default:
            if isPoppinsFont {
                self.font = UIFont(name: "Poppins-Regular", size: fontSize)
            }else {
                self.font = UIFont(name: "Segoe-UI", size: fontSize)
            }
        }
    }
}
