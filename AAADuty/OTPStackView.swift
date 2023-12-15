//
//  OTPStackView.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}



protocol OTPDelegate: AnyObject {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
}

class OTPStackView: UIStackView {
    let numberOfFields = 6
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    //Colors
    let inactiveFieldBorderColor = UIColor(red: 38/255, green: 111/255, blue: 158/255, alpha: 1)
    let textBackgroundColor = UIColor(red: 25/255, green: 55/255, blue: 82/255, alpha: 1)
    let activeFieldBorderColor = UIColor(red: 38/255, green: 111/255, blue: 158/255, alpha: 1)
    var remainingStrStack: [String] = []
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    //Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 15
    }
    
    //Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField){
        let width = (((screenWidth - 30)*0.9) - 75)/6
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: width).isActive = true
        textField.widthAnchor.constraint(equalToConstant: width).isActive = true
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: "Trebuchet MS", size: 20)
        textField.textColor = UIColor(red: 116/255, green: 162/255, blue: 207/255, alpha: 1)
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        textField.keyboardType = .numberPad
        //        textField.autocorrectionType = .yes
        //        textField.textContentType = .oneTimeCode
    }
    
    //checks if all the OTPfields are filled
    private final func checkForValidity(){
        for fields in textFieldsCollection{
            if (fields.text == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    //gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    //set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
    
    func emptyTextfields() {
        DispatchQueue.main.async {
            for textfield in self.textFieldsCollection {
                textfield.text = ""
            }
        }
    }
}

//MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0 && string == "") {
                return false
            } else if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
}

