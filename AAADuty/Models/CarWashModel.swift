//
//  CarWashModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 10/03/23.
//

import Foundation

// MARK: - CarWashVendorsModel
struct CarWashVendorsModel: Codable {
    let status: String?
    let statusCode: Int?
    let message: String?
    var data: [CarWashVendor]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct CarWashVendor: Codable {
    let location: ServiceLocation?
    let id, aadhar: String?
    let aadharBackPic, aadharPicFront: String?
    let address, bussinessClosingHours, bussinessOpenHours: String?
    let businessPics: [BusinessPic]?
    let city, companyName, fullName: String?
    let latitude, longitude: Double?
    let pan: String?
    let panPic: String?
    let percentage, pinCode: Int?
    let primaryPhoneNumber: String?
    let profilePic: String?
    let secondaryPhoneNumber: String?
    let services: [CarWashService]?
    let state, userID, categoryID, categoryName: String?
    let isActive: Bool?
    let bankName, branch, ifsccode, accountNumber: String?
    let outstandingAmount: Int?
    let paymentTypeID, paymentType: String?
    let payments: [Payment]?
//    let transactions: [JSONAny]?
    let v: Int?
//    let capturedName, pics: JSONNull?
    let contactID, fundID: String?
    let isBankDetailsUpdated, vendorSlotsStatus: Bool?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case location = "Location"
        case id = "_id"
        case aadhar = "Aadhar"
        case aadharBackPic = "AadharBackPic"
        case aadharPicFront = "AadharPicFront"
        case address = "Address"
        case bussinessClosingHours = "BussinessClosingHours"
        case bussinessOpenHours = "BussinessOpenHours"
        case businessPics
        case city = "City"
        case companyName = "CompanyName"
        case fullName = "FullName"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case pan = "PAN"
        case panPic
        case percentage = "Percentage"
        case pinCode
        case primaryPhoneNumber = "PrimaryPhoneNumber"
        case profilePic
        case secondaryPhoneNumber = "SecondaryPhoneNumber"
        case services = "Services"
        case state = "State"
        case userID = "UserId"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case isActive
        case bankName = "BankName"
        case branch = "Branch"
        case ifsccode = "Ifsccode"
        case accountNumber = "AccountNumber"
        case outstandingAmount = "OutstandingAmount"
        case paymentTypeID = "PaymentTypeID"
        case paymentType = "PaymentType"
        case payments = "Payments"
//        case transactions = "Transactions"
        case v = "__v"
//        case capturedName = "CapturedName"
//        case pics = "Pics"
        case contactID = "contact_id"
        case fundID = "fund_id"
        case isBankDetailsUpdated
        case vendorSlotsStatus = "VendorSlotsStatus"
    }
}

// MARK: - BusinessPic
struct BusinessPic: Codable {
    let id: String?
    let pic: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pic = "Pic"
    }
}

// MARK: - Location
struct ServiceLocation: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Payment
struct Payment: Codable {
    let id, requestID, requestDate: String?
    let amount: Int?
    let orderID, paymentDate, note: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case requestID = "RequestID"
        case requestDate = "RequestDate"
        case amount = "Amount"
        case orderID = "OrderID"
        case paymentDate = "PaymentDate"
        case note = "Note"
    }
}

// MARK: - Service
struct CarWashService: Codable {
    let id: String?
    let imageURL: String?
    let price: String?
    let serviceName: String?
    let typeID: String?
    let typeName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageURL
        case price = "Price"
        case serviceName = "ServiceName"
        case typeID = "TypeID"
        case typeName = "TypeName"
    }
}



