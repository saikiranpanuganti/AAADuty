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
    let categories: [SubCategory]?

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
