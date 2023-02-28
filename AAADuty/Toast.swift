//
//  Toast.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import Foundation





//
//  Notify.swift
//  JawwyTV
//
//  Created by Maneesh M on 04/02/21.
//  Copyright © 2021 Intigral . All rights reserved.
//

import UIKit

struct Notify {
    private init() {  }

    static func showToastWith(text:String) {
        DispatchQueue.main.async {
            dismissToast()
            let height = text.height(withConstrainedWidth: screenWidth - 120, font: UIFont(name: "Trebuchet MS", size: 16))
            let toast = Toast(frame: CGRect(x: 20, y: screenHeight - 100, width: screenWidth - 40, height: height + 30))
            toast.layer.cornerRadius = 10
            toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            toast.text = text
            
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.window?.addSubview(toast)
            }
        }
    }
    
    static func dismissToast() {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            for view in scene.window?.subviews ?? [] {
                if let toast = view as? Toast {
                    toast.removeFromSuperview()
                }
            }
        }
    }
}


class Toast: UIView {
    var label: UILabel?
    var button: UIButton?
    
    var text: String = "" {
        didSet {
            label?.text = text
        }
    }
    var showButton: Bool = true {
        didSet {
            button?.isHidden = showButton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 10, y: 0, width: (frame.width - 80), height: frame.height))
        if let label = label {
            label.font = UIFont(name: "Trebuchet MS", size: 16)
            label.textColor = UIColor.white
            label.numberOfLines = 0
            label.text = text
            addSubview(label)
        }
        
        button = UIButton(frame: CGRect(x: (frame.width - 60.0), y: 0, width: 40, height: frame.height))
        if let button = button {
            button.setTitle("OK", for: .normal)
            button.backgroundColor = UIColor.clear
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            button.titleLabel?.font = UIFont(name: "Trebuchet MS Bold", size: 16)
            button.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
            addSubview(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func okTapped() {
        NotificationCenter.default.post(name: NSNotification.Name(retrylocationAccess), object: nil)
    }
}

