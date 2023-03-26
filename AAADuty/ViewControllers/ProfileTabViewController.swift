//
//  ProfileTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

struct ProfileData {
    var mobile: String?
    var name: String?
    var email: String?
    var gender: String?
    var birthday: String?
    var address: String?
}


class ProfileTabViewController: BaseViewController {
    @IBOutlet weak var profileImageBackgroundView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var birthdayTextfield: UITextField!
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mobileLabel: UILabel!
    
    var areTextfieldsEnabled: Bool = false
    var userGender: String = "male"
    
    var userDetails: User? {
        return AppData.shared.user
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        disableTextfields()
        updateUser()
    }
    
    func setUpViews() {
        addBorderToViews()
        profileImageBackgroundView.layer.cornerRadius = 55
        profileImageBackgroundView.layer.borderColor = UIColor(red: 56/255, green: 136/255, blue: 207/255, alpha: 1).cgColor
        profileImageBackgroundView.layer.borderWidth = 1
        profileImageBackgroundView.layer.masksToBounds = true
        
        saveButton.layer.cornerRadius = 8
        saveButton.layer.masksToBounds = true
        
        mobileLabel.attributedText = "Mobile Number*".partiallyColoredText("*", with: UIColor.red)
    }
    
    func addBorderToViews() {
        addBorder(to: mobileView)
        addBorder(to: nameView)
        addBorder(to: emailView)
        addBorder(to: genderView)
        addBorder(to: birthdayView)
        addBorder(to: addressView)
        addBorder(to: femaleView)
        addBorder(to: maleView)
        emailView.bringSubviewToFront(emailLabel)
        birthdayView.bringSubviewToFront(birthdayLabel)
        addressView.bringSubviewToFront(addressLabel)
    }
    
    func addBorder(to view: UIView) {
        view.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        view.layer.borderWidth = 1
    }
    
    func enableTextfields() {
        mobileTextfield.isEnabled = true
        nameTextfield.isEnabled = true
        emailTextfield.isEnabled = true
        birthdayTextfield.isEnabled = true
        addressTextfield.isEnabled = true
        editImageButton.isHidden = false
        editButton.isHidden = true
        mobileTextfield.becomeFirstResponder()
        
        areTextfieldsEnabled = true
    }
    func disableTextfields() {
        mobileTextfield.isEnabled = false
        nameTextfield.isEnabled = false
        emailTextfield.isEnabled = false
        birthdayTextfield.isEnabled = false
        addressTextfield.isEnabled = false
        editImageButton.isHidden = true
        editButton.isHidden = false
        
        areTextfieldsEnabled = false
    }
    
    func updateUser() {
        if let userDetails = userDetails {
            mobileTextfield.text = userDetails.mobileNumber
            nameTextfield.text = userDetails.customerName
            emailTextfield.text = userDetails.email
            birthdayTextfield.text = userDetails.dob
            addressTextfield.text = userDetails.address?.first?.address
            if userDetails.gender == "male" {
                maleButton.tintColor = UIColor(red: 1, green: 91/255, blue: 91/255, alpha: 1)
                femaleButton.tintColor = UIColor.black
                userGender = "male"
            }else {
                femaleButton.tintColor = UIColor(red: 1, green: 91/255, blue: 91/255, alpha: 1)
                maleButton.tintColor = UIColor.black
                userGender = "female"
            }
        }
    }
    
    func updateUserDetails() {
        
    }
    
    @IBAction func maleTapped() {
        if areTextfieldsEnabled {
            maleButton.tintColor = UIColor(red: 1, green: 91/255, blue: 91/255, alpha: 1)
            femaleButton.tintColor = UIColor.black
            userGender = "male"
        }
    }
    @IBAction func femaleTapped() {
        if areTextfieldsEnabled {
            femaleButton.tintColor = UIColor(red: 1, green: 91/255, blue: 91/255, alpha: 1)
            maleButton.tintColor = UIColor.black
            userGender = "female"
        }
    }
    
    @IBAction func editTapped() {
        if areTextfieldsEnabled {
            disableTextfields()
        }else {
            enableTextfields()
        }
    }
    
    @IBAction func profileImageTapped() {
        
    }
    
    @IBAction func saveTapped() {
        if let mobileText = mobileTextfield.text, mobileText.replacingOccurrences(of: " ", with: "") != "" {
            var updatedUser = userDetails
            updatedUser?.mobileNumber = mobileText
            updatedUser?.customerName = nameTextfield.text ?? ""
            updatedUser?.email = emailTextfield.text ?? ""
            updatedUser?.gender = userGender
            updatedUser?.dob = birthdayTextfield.text ?? ""
            if var userAddress = updatedUser?.address?.first {
                userAddress.address = addressTextfield.text ?? ""
                updatedUser?.address = [userAddress]
            }else {
                updatedUser?.address = [Address(address: addressTextfield.text ?? "")]
            }
            
            updateUserDetails()
        }else {
            showAlert(title: "Error", message: "Please enter valid mobile number")
        }
    }
}
