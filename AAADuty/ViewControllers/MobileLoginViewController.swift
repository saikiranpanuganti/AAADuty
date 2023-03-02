//
//  MobileLoginViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

class MobileLoginViewController: BaseViewController {
    @IBOutlet weak var mobileTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        mobileTextfield.tintColor = UIColor.white
        mobileTextfield.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 112/255, green: 162/255, blue: 207/255, alpha: 1)])
        mobileTextfield.delegate = self
        mobileTextfield.becomeFirstResponder()
    }
    
    func sendOTP() {
        showLoader()
        if let mobileNumber = mobileTextfield.text {
            let bodyParams: [String: Any] = ["MobileNumber": mobileNumber]
            NetworkAdaptor.requestWithHeaders(urlString: Url.generateOtp.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                self?.stopLoader()
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let statusCode = jsonResponse["Status"] as? String, statusCode == "SUCCESS" {
                                self?.navigateToOTPScreen()
                            }else {
                                if let errorMessage = jsonResponse["Message"] as? String ?? jsonResponse["message"] as? String {
                                    self?.showAlert(title: "Error", message: errorMessage)
                                }else {
                                    self?.showAlert(title: "Error", message: "Something went wrong")
                                }
                            }
                        }else {
                            self?.showAlert(title: "Error", message: "Something went wrong")
                        }
                    }catch {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }else {
                    self?.showAlert(title: "Error", message: "Something went wrong")
                }
            }
        }
    }
    
    func navigateToOTPScreen() {
        DispatchQueue.main.async { [weak self] in
            if let otpVC = Controllers.otpVc.getController() as? OTPViewController {
                otpVC.mobileNumber = self?.mobileTextfield.text ?? ""
                self?.navigationController?.pushViewController(otpVC, animated: true)
            }
        }
    }

    @IBAction func sendOtpTapped() {
        sendOTP()
    }
}


extension MobileLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mobileTextfield.resignFirstResponder()
    }
}
