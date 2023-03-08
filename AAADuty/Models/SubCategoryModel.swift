//
//  SubCategoryModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 02/03/23.
//

import Foundation

// MARK: - SubCategoryModel
struct SubCategoryModel: Codable {
    let status, statusCode, message: String?
    var categories: [SubCategory]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case categories
    }
}

// MARK: - Category
struct SubCategory: Codable {
    let id, categoryID, categoryName, typeName: String?
    let sortOrder: Int?
    let imageURL: String?
    let isActive: Bool?
    let v: Int?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case typeName = "TypeName"
        case sortOrder = "SortOrder"
        case imageURL = "ImageURL"
        case isActive = "IsActive"
        case v = "__v"
    }
}


// MARK: - ComplaintTypeModel
struct ComplaintTypeModel: Codable {
    let status, statusCode, message: String?
    let complaintTypes: [ComplaintType]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case complaintTypes = "ComplaintTypes"
    }
}

// MARK: - ComplaintType
struct ComplaintType: Codable {
    let id, typeID, typeName, categoryID: String?
    let categoryName, complaint: String?
    let imageURL: String?
    let price, serviceCharge: Int?
    let noOfItemsButton, isActive: Bool?
    let pgServiceTax, gst: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case complaint = "Complaint"
        case imageURL
        case price = "Price"
        case serviceCharge = "ServiceCharge"
        case noOfItemsButton = "NoOfItemsButton"
        case isActive
        case pgServiceTax = "PGServiceTax"
        case gst = "GST"
    }
}





// MARK: - VechicleTypeModel
struct VechicleTypeModel: Codable {
    let status, statusCode, message: String?
    var response: [VechicleType]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - Response
struct VechicleType: Codable {
    let id, vehileType, typeID, typeName: String?
    let categoryID, categoryName: String?
    let imageURL: String?
    let isActive: Bool?
    let v: Int?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vehileType = "VehileType"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case imageURL = "ImageURL"
        case isActive = "IsActive"
        case v = "__v"
    }
}
