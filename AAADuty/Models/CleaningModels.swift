//
//  CleaningModels.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit


// MARK: - SubCategoryTypesModel
struct SubCategoryTypesModel: Codable {
    let status, statusCode, message: String?
    var response: [SubCategoryType]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - SubCategoryType
struct SubCategoryType: Codable {
    let id, subCategoryName, categoryID, categoryName: String?
    let typeID, typeName: String?
    let imageURL: String?
    let isActive: Bool?
    var isSelected: Bool = false
    var isAdded: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case subCategoryName = "SubCategoryName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case imageURL
        case isActive = "IsActive"
    }
}




// MARK: - CleaningServicesModel
struct CleaningServicesModel: Codable {
    let status, statusCode, message: String?
    var response: [CleaningService]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - Response
struct CleaningService: Codable {
    let id, subCateogryID, subCategoryName, categoryID: String?
    let categoryName, typeID, typeName, serviceName: String?
    let price, sortOrder: Int?
    let isActive: Bool?
    let imageURL: String?
    let description, longDescription: String?
    let pgServiceTax, v: Int?
    var count: Int = 0

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case subCateogryID = "SubCateogryID"
        case subCategoryName = "SubCategoryName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case serviceName = "ServiceName"
        case price = "Price"
        case sortOrder = "SortOrder"
        case isActive = "IsActive"
        case imageURL = "ImageURL"
        case description = "Description"
        case longDescription = "LongDescription"
        case pgServiceTax = "PGServiceTax"
        case v = "__v"
    }
}
