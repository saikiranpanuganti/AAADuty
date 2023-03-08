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
    
    var serviceType: ServiceType {
        if let id = id {
            switch id {
            case "61234c0930fd466a54bd250d":
                return ServiceType.flatTyre
            case "61234e0fa782e16a6fc4fc58":
                return ServiceType.towing
            case "61234e46ea21b46a7d44739c":
                return ServiceType.vechicletech
            case "61c198214ee3da924a153d48":
                return ServiceType.carWash
            case "6251428b4ee3da924a25afa3":
                return ServiceType.wrooz
            case "61234f4006bb5c6ac41d6240":
                return ServiceType.cleaning
            case "61234ee6392a246aaa1496e1":
                return ServiceType.sanitization
            case "61234f785ef8506acf1f8c40":
                return ServiceType.plumbing
            case "61234e74008f776a8a6b9b8e":
                return ServiceType.acTech
            case "61234ec88f93136aa08b31b7":
                return ServiceType.electrician
            case "61234f1234668a6aba7391ee":
                return ServiceType.pestControl
            case "61234ead8e8da36a95580a86":
                return ServiceType.gasTech
            default:
                return ServiceType.none
            }
        }else {
            return ServiceType.none
        }
    }
    
    var subCategoryMessage: String {
        if let id = id {
            switch id {
            case "61234c0930fd466a54bd250d":
                return "Select type of Vehicle"
            case "61234e0fa782e16a6fc4fc58":
                return "Select your towing type"
            case "61234e46ea21b46a7d44739c":
                return "Select type of Vehicle"
            case "61c198214ee3da924a153d48":
                return ""
            case "6251428b4ee3da924a25afa3":
                return ""
            case "61234f4006bb5c6ac41d6240":
                return ""
            case "61234ee6392a246aaa1496e1":
                return ""
            case "61234f785ef8506acf1f8c40":
                return ""
            case "61234e74008f776a8a6b9b8e":
                return ""
            case "61234ec88f93136aa08b31b7":
                return ""
            case "61234f1234668a6aba7391ee":
                return ""
            case "61234ead8e8da36a95580a86":
                return ""
            default:
                return ""
            }
        }else {
            return ""
        }
    }
    
    var subCategorySectionMessage: String {
        if let id = id {
            switch id {
            case "61234e46ea21b46a7d44739c":
                return "Select type of CAR"
            case "61c198214ee3da924a153d48":
                return ""
            case "6251428b4ee3da924a25afa3":
                return ""
            case "61234f4006bb5c6ac41d6240":
                return ""
            case "61234ee6392a246aaa1496e1":
                return ""
            case "61234f785ef8506acf1f8c40":
                return ""
            case "61234e74008f776a8a6b9b8e":
                return ""
            case "61234ec88f93136aa08b31b7":
                return ""
            case "61234f1234668a6aba7391ee":
                return ""
            case "61234ead8e8da36a95580a86":
                return ""
            default:
                return ""
            }
        }else {
            return ""
        }
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
