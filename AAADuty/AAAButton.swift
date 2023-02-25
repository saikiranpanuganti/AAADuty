//
//  AAAButton.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

@IBDesignable class AAAButton: UIButton {
    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            switch AAAFontWeight(rawValue: fontWeight) {
            case .light:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .medium:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .semibold:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            case .bold:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            default:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        }
    }
    
    @IBInspectable var fontWeight: Int = 1 {
        didSet {
            switch AAAFontWeight(rawValue: fontWeight) {
            case .light:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .medium:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
            case .semibold:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            case .bold:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS Bold", size: fontSize)
            default:
                self.titleLabel?.font = UIFont(name: "Trebuchet MS", size: fontSize)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
