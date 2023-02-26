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
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }else {
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        case .medium:
            if isPoppinsFont {
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }else {
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        case .semibold:
            if isPoppinsFont {
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            }else {
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            }
        case .bold:
            if isPoppinsFont {
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            }else {
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            }
        default:
            if isPoppinsFont {
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }else {
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        }
    }
}
