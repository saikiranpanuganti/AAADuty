//
//  OTPViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

class OTPViewController: UIViewController {
    @IBOutlet weak var otpView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let otpStackView = OTPStackView()
        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
    }

}

extension OTPViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        
    }
}
