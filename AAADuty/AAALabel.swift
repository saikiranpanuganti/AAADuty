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

@IBDesignable class AAALabel: UILabel {

    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            switch AAAFontWeight(rawValue: fontWeight) {
            case .light:
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .medium:
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .semibold:
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            case .bold:
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            default:
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        }
    }
    
    @IBInspectable var fontWeight: Int = 1 {
        didSet {
            switch AAAFontWeight(rawValue: fontWeight) {
            case .light:
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .medium:
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .semibold:
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            case .bold:
                self.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            default:
                self.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        }
    }
}
