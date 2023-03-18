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
    var color: UIColor = UIColor.random

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
