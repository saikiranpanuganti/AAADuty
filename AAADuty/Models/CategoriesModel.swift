//
//  CategoriesModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import Foundation

// MARK: - CategoriesModel
struct CategoriesModel: Codable {
    let status, statusCode, message: String?
    let categories: [Category]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case categories
    }
}

// MARK: - Category
struct Category: Codable {
    let id, category: String?
    let gst: Int?
    let isActive: Bool?
    let imageURL: String?
    let tabImageURL: String?
    let requestImageURL: String?
    let colorCode: String?
    let openTime: OpenTime?
    let closeTime: CloseTime?
    let opening, closing: Int?
    let message: String?
    let sortOrder, v: Int?
    let instructions: [Instruction]?
    let serviceCharge, pgServiceTax: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case category = "Category"
        case gst = "GST"
        case isActive
        case imageURL = "ImageURL"
        case tabImageURL = "TabImageURL"
        case requestImageURL = "RequestImageURL"
        case colorCode = "ColorCode"
        case openTime = "OpenTime"
        case closeTime = "CloseTime"
        case opening = "Opening"
        case closing = "Closing"
        case message
        case sortOrder = "SortOrder"
        case v = "__v"
        case instructions = "Instructions"
        case serviceCharge = "ServiceCharge"
        case pgServiceTax = "PGServiceTax"
    }
}

enum CloseTime: String, Codable {
    case pm = "PM"
}

// MARK: - Instruction
struct Instruction: Codable {
    let people: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case people = "People"
        case imageURL = "ImageURL"
    }
}

enum OpenTime: String, Codable {
    case am = "AM"
}
