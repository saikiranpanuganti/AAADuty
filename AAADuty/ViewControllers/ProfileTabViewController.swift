//
//  ProfileTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit
import AWSS3

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
    @IBOutlet weak var backButton: UIButton!
    
    var areTextfieldsEnabled: Bool = false
    var hideBackButton: Bool = true
    var userGender: String = "male"
    
    var userDetails: User? {
        return AppData.shared.user
    }
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        setUpViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSuccess), name: NSNotification.Name(loginSuccess), object: nil)
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
        
        if hideBackButton {
            backButton.isHidden = true
        }
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
    
    @objc func handleLoginSuccess() {
        
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
            if let image = userDetails.avatar {
                print("userDetails.avatar: - \(image)")
                profileImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile"), options: .refreshCached)
            }
        }
    }
    

    func uploadData(data: Data, imageName: String) {
      let expression = AWSS3TransferUtilityUploadExpression()
//      expression.progressBlock = {(task, progress) in
//          DispatchQueue.main.async(execute: {
//              print("AWS Progress: progress - \(progress.fractionCompleted) task - \(task) \(progress.fileURL)")
//          })
//      }

      var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
      completionHandler = { (task, error) -> Void in
         DispatchQueue.main.async(execute: {
             if error == nil {
                 AppData.shared.user?.avatar = "https://aaadutyv1.s3.ap-south-1.amazonaws.com/" + imageName
                 AppData.shared.user?.saveUser()
             }
         })
      }

      let transferUtility = AWSS3TransferUtility.default()
      transferUtility.uploadData(data,
           bucket: "aaadutyv1",
           key: imageName,
           contentType: "image/jpeg",
           expression: expression,
           completionHandler: completionHandler).continueWith {
              (task) -> AnyObject? in
                  if let error = task.error {
                     print("AWS Error: \(error.localizedDescription)")
                  }
                  return nil;
          }
    }
      
    
    func updateUserDetails(updatedUser: User?) {
        if let updatedUser = updatedUser {
            showLoader()
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(updatedUser)
                
                if let bodyParams = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
                    print("bodyParams - \(bodyParams)")
                    
                    NetworkAdaptor.requestWithHeaders(urlString: Url.updateUserDetails.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                        guard let self = self else { return }
                        self.stopLoader()
                        
                        if let data = data {
                            do {
                                let userDetail = try JSONDecoder().decode(UpdatedUserModel.self, from: data)
                                print("userDetail - \(userDetail)")
                                if userDetail.userData?.id != nil {
                                    userDetail.userData?.saveUser()
                                    AppData.shared.user = userDetail.userData
                                }
                            }catch {
                                print("Error: ProfileTabViewController updateUserDetails data - \(error)")
                            }
                        }
                    }
                }
            } catch {
                print("Error: ProfileTabViewController updateUserDetails body - \(error) ")
            }
        }
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
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
            
            updateUserDetails(updatedUser: updatedUser)
        }else {
            showAlert(title: "Error", message: "Please enter valid mobile number")
        }
    }
    
    @IBAction func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension ProfileTabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = pickedImage
            if let jpegData = pickedImage.jpegData(compressionQuality: 0.5), let userid = AppData.shared.user?.id {
                print("picked Image: - \(jpegData) imageName - \(userid+"/profileImage")")
                uploadData(data: jpegData, imageName: userid+"/profileImage")
            }
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
