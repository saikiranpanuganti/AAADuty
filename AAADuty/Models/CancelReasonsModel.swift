//
//  CancelReasonsModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import Foundation

// MARK: - CancelReasonsModel
struct CancelReasonsModel: Codable {
    let status, statusCode, message: String?
    var reasons: [CancelReason]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case reasons = "Reasons"
    }
}

// MARK: - Reason
struct CancelReason: Codable {
    let id, categoryID, categoryName, reason: String?
    let isActive: Bool?
    let v: Int?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case reason = "Reason"
        case isActive
        case v = "__v"
    }
}
