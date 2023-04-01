//
//  RequestDetailsModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 31/03/23.
//


import Foundation

// MARK: - RequestDetailsModel
struct RequestDetailsModel: Codable {
    let status, statusCode, message: String?
    let response: [RequestDetails]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - Response
struct RequestDetails: Codable {
    let destinationLocation: DestinationLocation?
    let id, customerID, customerName, customerPhoneNumber: String?
    let desinationAddress: String?
    let destinationLat, destinationLong: Double?
    let services: [Service]?
//    let problems: [JSONAny]?
    let distance: Double?
    let note, categoryID, categoryName, paymentStatus: String?
    let typeID, typeName, date, notificationStatus: String?
    let franchiseNote, assignedFranchiseID, assignedFranchiseName, assignedFranchsiePhoneNumber: String?
    let assignedFranchiseStateID, assignedFranchiseState, assignedFranchiseDistrictID, assignedFranchiseDistrictName: String?
    let assignedFranchiseStoreAddress, assignedFranchiseArea, assignedFranchisePinCode, assignedFranchiseCode: String?
    let statusTracking: [StatusTracking]?
    let assignedTechinicianID, assignedTechnicianName: String?
    let assignedTechnicianPhoneNumber: Int?
    let requestStatus, orderID: String?
    let serviceImageURL: String?
    let price, gst, serviceTax, totalAmount: Int?
//    let beforePics: [JSONAny]?
    let afterPics: [AfterPic]?
//    let woozInstructions, ticketStatus: [JSONAny]?
    let v, addTip: Int?
    let assignedFranchiseComments: String?
    let requestImageURL: String?

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
        case assignedFranchiseArea = "AssignedFranchiseArea"
        case assignedFranchisePinCode = "AssignedFranchisePinCode"
        case assignedFranchiseCode = "AssignedFranchiseCode"
        case statusTracking = "StatusTracking"
        case assignedTechinicianID = "AssignedTechinicianID"
        case assignedTechnicianName = "AssignedTechnicianName"
        case assignedTechnicianPhoneNumber = "AssignedTechnicianPhoneNumber"
        case requestStatus = "RequestStatus"
        case orderID = "OrderID"
        case serviceImageURL = "ServiceImageURL"
        case price = "Price"
        case gst = "GST"
        case serviceTax = "ServiceTax"
        case totalAmount = "TotalAmount"
//        case beforePics = "BeforePics"
        case afterPics = "AfterPics"
//        case woozInstructions = "WoozInstructions"
//        case ticketStatus = "TicketStatus"
        case v = "__v"
        case addTip = "AddTip"
        case assignedFranchiseComments = "AssignedFranchiseComments"
        case requestImageURL = "RequestImageURL"
    }
}

// MARK: - AfterPic
struct AfterPic: Codable {
    let id: String?
    let pics: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pics = "Pics"
    }
}

// MARK: - Service
struct Service: Codable {
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

// MARK: - StatusTracking
struct StatusTracking: Codable {
    let isActive: Bool?
    let id, currentStatus, dateTime, note: String?
    let notificationType: String?

    enum CodingKeys: String, CodingKey {
        case isActive
        case id = "_id"
        case currentStatus = "CurrentStatus"
        case dateTime = "DateTime"
        case note = "Note"
        case notificationType = "NotificationType"
    }
}



