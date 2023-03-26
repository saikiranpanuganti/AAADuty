//
//  PastOrdersModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/03/23.
//

import Foundation


// MARK: - OrdersModel
struct PastOrdersModel: Codable {
    let status: String?
    let statusCode: Int?
    let message: String?
    let pastorders: [PastOrder]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case pastorders
    }
}

// MARK: - Pastorder
struct PastOrder: Codable {
    let destinationLocation: DestinationLocation?
    let id, customerID, customerName, customerPhoneNumber: String?
    let desinationAddress: String?
    let destinationLat, destinationLong: Double?
    let services: [OrderService]?
    let distance: Double?
    let note, categoryID, categoryName, paymentStatus: String?
    let typeID, typeName, date, notificationStatus: String?
    let franchiseNote, assignedFranchiseID, assignedFranchiseName, assignedFranchsiePhoneNumber: String?
    let assignedFranchiseStateID, assignedFranchiseState, assignedFranchiseDistrictID, assignedFranchiseDistrictName: String?
    let assignedFranchiseStoreAddress: String?
    let assignedFranchisePinCode, assignedFranchiseCode: String?
    let assignedTechinicianID, assignedTechnicianName: String?
    let requestStatus, orderID: String?
    let serviceImageURL, requestImageURL: String?
    let price, gst, serviceTax, totalAmount: Int?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case destinationLocation = "DestinationLocation"
        case id = "_id"
        case customerID = "CustomerID"
        case customerName = "CustomerName"
        case customerPhoneNumber = "CustomerPhoneNumber"
        case desinationAddress = "DesinationAddress"
        case destinationLat = "DestinationLat"
        case destinationLong = "DestinationLong"
        case services = "Services"
        case distance = "Distance"
        case note = "Note"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case paymentStatus = "PaymentStatus"
        case typeID, typeName
        case date = "Date"
        case notificationStatus = "NotificationStatus"
        case franchiseNote = "FranchiseNote"
        case assignedFranchiseID = "AssignedFranchiseId"
        case assignedFranchiseName = "AssignedFranchiseName"
        case assignedFranchsiePhoneNumber = "AssignedFranchsiePhoneNumber"
        case assignedFranchiseStateID = "AssignedFranchiseStateID"
        case assignedFranchiseState = "AssignedFranchiseState"
        case assignedFranchiseDistrictID = "AssignedFranchiseDistrictID"
        case assignedFranchiseDistrictName = "AssignedFranchiseDistrictName"
        case assignedFranchiseStoreAddress = "AssignedFranchiseStoreAddress"
        case assignedFranchisePinCode = "AssignedFranchisePinCode"
        case assignedFranchiseCode = "AssignedFranchiseCode"
        case assignedTechinicianID = "AssignedTechinicianID"
        case assignedTechnicianName = "AssignedTechnicianName"
        case requestStatus = "RequestStatus"
        case orderID = "OrderID"
        case serviceImageURL = "ServiceImageURL"
        case requestImageURL = "RequestImageURL"
        case price = "Price"
        case gst = "GST"
        case serviceTax = "ServiceTax"
        case totalAmount = "TotalAmount"
        case v = "__v"
    }
}


// MARK: - Service
struct OrderService: Codable {
    let id, categoryID, categoryName, complaint: String?
    let complaintID, noOfCount: String?
    let price: Int?
    let subCategoryID, subCategoryName, typeID, typeName: String?
    let isActive: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case complaint = "Complaint"
        case complaintID = "ComplaintID"
        case noOfCount = "NoOfCount"
        case price = "Price"
        case subCategoryID = "SubCategoryID"
        case subCategoryName = "SubCategoryName"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case isActive
    }
}






