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
