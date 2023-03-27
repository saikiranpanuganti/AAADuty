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
    case getVehicleProblems
    case getCarWashVendors
    case waitingTimes
    case getWoozPrice
    case getSubCategoryTypes
    case getCleaningServices
    case getCancelReasons
    case saveTransaction
    case cancelRequest
    case getPastOrders
    case updateUserDetails
    
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
        case .getVehicleProblems:
            return baseUrl + "/V1/getvehiclesproblems"
        case .getCarWashVendors:
            return baseUrl + "/V1/getcarwashvendors"
        case .waitingTimes:
            return baseUrl + "/V1/getwaitingtimes"
        case .getWoozPrice:
            return baseUrl + "/V1/getwoozserviceprices"
        case .getSubCategoryTypes:
            return baseUrl + "/V1/getsubcategorydetails"
        case .getCleaningServices:
            return baseUrl + "/V1/gethomeappliancesservicesdetails"
        case .getCancelReasons:
            return baseUrl + "/V1/getcancelreasons"
        case .saveTransaction:
            return baseUrl + "/V1/savetransactions"
        case .cancelRequest:
            return baseUrl + "/V1/cancelrequest"
        case .getPastOrders:
            return baseUrl + "/V1/getpastorders"
        case .updateUserDetails:
            return baseUrl + "/V1/updateuser"
        }
    }
}
