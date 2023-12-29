//
//  OTPViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

protocol OTPViewControllerDelegate: AnyObject {
    func shouldCloseController()
}

class OTPViewController: BaseViewController {
    @IBOutlet weak var otpView: UIView!

    weak var delegate: OTPViewControllerDelegate?
    let otpStackView = OTPStackView()
    var mobileNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
    }
    
    func getCategories() {
        NetworkAdaptor.requestWithHeaders(urlString: Url.categories.getUrl(), method: .get) { [weak self] data, response, error in
            if let data = data {
                do {
                    self?.stopLoader()
                    let cateogriesModel = try JSONDecoder().decode(CategoriesModel.self, from: data)
                    AppData.shared.categories = cateogriesModel.categories ?? []
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.pushViewController(Controllers.tabBar.getController(), animated: true)
                    }
                }catch {
                    print("Error: OTPViewController getCategories - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func resendOTP() {
        showLoader()
        
        let bodyParams: [String: Any] = ["MobileNumber": mobileNumber]
        
        NetworkAdaptor.requestWithHeaders(urlString: Url.resendOTP.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            self?.stopLoader()
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let statusCode = jsonResponse["StatusCode"] as? Int, statusCode == 200 {
                            self?.otpStackView.emptyTextfields()
                            self?.showAlert(title: "Success", message: "OTP Sent Successfully")
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
    
    func verifyOTP() {
        showLoader()
        
        let bodyParams: [String: Any] = ["MobileNumber": mobileNumber, "OTP": otpStackView.getOTP()]
        print("$$Login: Url -\(Url.validateUser.getUrl())")
        print("$$Login: bodyParams -\(bodyParams)")
        NetworkAdaptor.requestWithHeaders(urlString: Url.validateUser.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            guard let self = self else { return }
            self.stopLoader()
            
            if let data = data {
                do {
                    let userModel = try JSONDecoder().decode(UserModel.self, from: data)
                    if let user = userModel.userData,  userModel.status == "SUCCESS" {
                        AppData.shared.user = user
                        AppData.shared.user?.saveUser()
//                        self.getCategories()
                        
                        DispatchQueue.main.async {
                            self.delegate?.shouldCloseController()
                            NotificationCenter.default.post(name: NSNotification.Name(loginSuccess), object: nil)
                            print("$$Self - \(self), presenting - \(self.presentingViewController)")
                            self.navigationController?.popViewController(animated: false)
                        }
                    }else {
                        self.showAlert(title: "Error", message: "Something went wrong")
                    }
                }catch {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }else {
                self.showAlert(title: "Error", message: "Something went wrong")
            }
        }
    }

    @IBAction func resendOTPTapped() {
        resendOTP()
    }
    
    @IBAction func verifyOTPTapped() {
        verifyOTP()
    }
    
    @IBAction func backTapped() {
        navigationController?.popViewController(animated: false)
    }
}

extension OTPViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        
    }
}
