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



// MARK: - VechicleBrandsModel
struct VechicleBrandsModel: Codable {
    let status, statusCode, message: String?
    var response: [VechicleBrand]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - Response
struct VechicleBrand: Codable {
    let id, brand, vehicleTypeID, vehileType: String?
    let typeID, typeName, categoryID, categoryName: String?
    let isActive: Bool?
    let imageURL: String?
    let v: Int?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brand = "Brand"
        case vehicleTypeID = "VehicleTypeID"
        case vehileType = "VehileType"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case isActive = "IsActive"
        case imageURL = "ImageURL"
        case v = "__v"
    }
}



// MARK: - VechiclesModel
struct VechiclesModel: Codable {
    let status, statusCode, message: String?
    let response: [Vechicle]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - Response
struct Vechicle: Codable {
    let id, vehicleName, brandID, brand: String?
    let vehicleTypeID, vehileType, typeID, typeName: String?
    let categoryID, categoryName: String?
    let isActive: Bool?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vehicleName = "VehicleName"
        case brandID = "BrandID"
        case brand = "Brand"
        case vehicleTypeID = "VehicleTypeID"
        case vehileType = "VehileType"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case isActive = "IsActive"
        case v = "__v"
    }
}



// MARK: - VechicleProblemModel
struct VechicleProblemModel: Codable {
    let status, statusCode, message: String?
    let response: [VechicleProblem]?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case response
    }
}

// MARK: - Response
struct VechicleProblem: Codable {
    let id, problem: String?
    let vehicleTypeID: String?
    let vehicleType: String?
    let typeID: String?
    let typeName: String?
    let categoryID: String?
    let categoryName: String?
    let price, pgServiceTax, gst: Int?
    let isActive: Bool?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case problem = "Problem"
        case vehicleTypeID = "VehicleTypeID"
        case vehicleType = "VehicleType"
        case typeID = "TypeID"
        case typeName = "TypeName"
        case categoryID = "CategoryID"
        case categoryName = "CategoryName"
        case price = "Price"
        case pgServiceTax = "PGServiceTax"
        case gst = "GST"
        case isActive = "IsActive"
        case v = "__v"
    }
}

