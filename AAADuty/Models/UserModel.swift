//
//  UserModel.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import Foundation

// MARK: - CategoriesModel
struct UserModel: Codable {
    let status, statusCode, message: String?
    let userData: User?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case userData = "UserData"
    }
}

// MARK: - UserData
struct User: Codable {
    var id, customerName, email, dob: String?
    var avatar: String?
    var date, mobileNumber: String?
    var isProfileUpdated, isActive: Bool?
    var address: [Address]?
    var v: Int?
    var gender: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customerName = "CustomerName"
        case email = "Email"
        case dob = "DOB"
        case avatar = "Avatar"
        case date = "Date"
        case mobileNumber = "MobileNumber"
        case isProfileUpdated, isActive
        case address = "Address"
        case v = "__v"
        case gender = "Gender"
    }
    
    func saveUser() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: userData_UD)
        }
    }
    
    func removeUser() {
        UserDefaults.standard.set(nil, forKey: userData_UD)
    }
}

// MARK: - Address
struct Address: Codable {
    var id, address: String?
    var latitude, longitude: Int?
    var addressType: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case address = "Address"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case addressType
    }
}
