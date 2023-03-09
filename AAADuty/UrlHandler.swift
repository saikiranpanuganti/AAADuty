//
//  UrlHandler.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//


import Foundation

fileprivate var baseUrl = "https://3m7wx2g9bb.execute-api.ap-south-1.amazonaws.com"


enum Url {
    case categories
    case generateOtp
    case resendOTP
    case validateUser
    case getTypes
    case getComplaintTypes
    case checkRequestAvailability
    case orderRequest
    case getVechicleType
    case getVehicleBrands
    case getVehicles
    
    func getUrl() -> String {
        switch self {
        case .categories:
            return baseUrl + "/V1/getcategories"
        case .generateOtp:
            return baseUrl + "/V1/generateuserotp"
        case .resendOTP:
            return baseUrl + "/V1/generateuserotp"
        case .validateUser:
            return baseUrl + "/V1/validateuser"
        case .getTypes:
            return baseUrl + "/V1/gettypes"
        case .getComplaintTypes:
            return baseUrl + "/V1/getcomplainttypes"
        case .checkRequestAvailability:
            return baseUrl + "/V1/requestcheckavailability"
        case .orderRequest:
            return baseUrl + "/V1/customerrequest"
        case .getVechicleType:
            return baseUrl + "/V1/getvehicletypes"
        case .getVehicleBrands:
            return baseUrl + "/V1/getvehiclebrands"
        case .getVehicles:
            return baseUrl + "/V1/getvehicles"
        }
    }
}
