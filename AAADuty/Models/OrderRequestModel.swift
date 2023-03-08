//
//  OrderRequestModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 08/03/23.
//

import Foundation

// MARK: - OrderRequestModel
struct OrderRequestModel: Codable {
    let status: String?
    let statusCode: Int?
    let message: String?
    let requestData: OrderRequest?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case requestData = "RequestData"
    }
}

// MARK: - RequestData
struct OrderRequest: Codable {
    let id, customerID, customerName: String?
    let destinationLocation: DestinationLocation?
    let destinationLat, destinationLong: Double?
    let services: [Service]?
//    let problems: [JSONAny]?
    let distance: Int?
    let note, categoryID, categoryName, paymentStatus: String?
    let typeID, typeName, date, notificationStatus: String?
    let franchiseNote, assignedFranchiseID, assignedFranchiseName, assignedFranchsiePhoneNumber: String?
    let assignedFranchiseStateID, assignedFranchiseState, assignedFranchiseDistrictID, assignedFranchiseDistrictName: String?
    let assignedFranchiseStoreAddress: String?
//    let assignedFranchiseArea: JSONNull?
    let assignedFranchisePinCode, assignedFranchiseCode: String?
//    let statusTracking: [JSONAny]?
    let assignedTechinicianID, assignedTechnicianName: String?
//    let assignedTechnicianPhoneNumber: JSONNull?
    let requestStatus, orderID: String?
    let serviceImageURL, requestImageURL: String?
    let price, gst, serviceTax, totalAmount: Int?
//    let beforePics, afterPics, woozInstructions, ticketStatus: [JSONAny]?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customerID = "CustomerID"
        case customerName = "CustomerName"
        case destinationLocation = "DestinationLocation"
        case destinationLat = "DestinationLat"
        case destinationLong = "DestinationLong"
        case services = "Services"
//        case problems = "Problems"
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
//        case assignedFranchiseArea = "AssignedFranchiseArea"
        case assignedFranchisePinCode = "AssignedFranchisePinCode"
        case assignedFranchiseCode = "AssignedFranchiseCode"
//        case statusTracking = "StatusTracking"
        case assignedTechinicianID = "AssignedTechinicianID"
        case assignedTechnicianName = "AssignedTechnicianName"
//        case assignedTechnicianPhoneNumber = "AssignedTechnicianPhoneNumber"
        case requestStatus = "RequestStatus"
        case orderID = "OrderID"
        case serviceImageURL = "ServiceImageURL"
        case requestImageURL = "RequestImageURL"
        case price = "Price"
        case gst = "GST"
        case serviceTax = "ServiceTax"
        case totalAmount = "TotalAmount"
//        case beforePics = "BeforePics"
//        case afterPics = "AfterPics"
//        case woozInstructions = "WoozInstructions"
//        case ticketStatus = "TicketStatus"
        case v = "__v"
    }
}

// MARK: - DestinationLocation
struct DestinationLocation: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Service
struct Service: Codable {
    let id, categoryID, categoryName, complaint: String?
    let noOfCount: String?
    let price: Int?
    let typeID, typeName, isActive: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case complaint = "Complaint"
        case noOfCount = "NoOfCount"
        case price = "Price"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case isActive
    }
}
