//
//  WoozModels.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 17/03/23.
//

import Foundation


// MARK: - WaitingTimesModel
struct WaitingTimesModel: Codable {
    let status: String?
    let data: [WaitingTime]?

    enum CodingKeys: String, CodingKey {
        case status
        case data = "Data"
    }
}

// MARK: - WaitingTime
struct WaitingTime: Codable {
    let id: String?
    let waitingTime: Int?
    let isActive: Bool?
    let v: Int?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case waitingTime = "WaitingTime"
        case isActive
        case v = "__v"
    }
}




// MARK: - WoozPriceModel
struct WoozPriceModel: Codable {
    let status: String?
    let data: [WoozPrice]?

    enum CodingKeys: String, CodingKey {
        case status
        case data = "Data"
    }
}

// MARK: - WoozPrice
struct WoozPrice: Codable {
    let id, serviceName, categoryID, categoryName: String?
    let perKM, waitingPeriod, waitingPeriodPrice, serviceCharge: Int?
    let imageURL: String?
    let isActive: Bool?
    let v, pgServiceTax, gst: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case serviceName = "ServiceName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case perKM = "PerKM"
        case waitingPeriod = "WaitingPeriod"
        case waitingPeriodPrice = "WaitingPeriodPrice"
        case serviceCharge = "ServiceCharge"
        case imageURL = "ImageURL"
        case isActive = "IsActive"
        case v = "__v"
        case pgServiceTax = "PGServiceTax"
        case gst = "GST"
    }
}

