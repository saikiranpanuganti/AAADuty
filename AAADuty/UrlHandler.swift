//
//  UrlHandler.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//


import Foundation

enum Url {
    case categories
    case generateOtp
    case resendOTP
    case validateUser
    
    func getUrl() -> String {
        switch self {
        case .categories:
            return "https://3m7wx2g9bb.execute-api.ap-south-1.amazonaws.com/V1/getcategories"
        case .generateOtp:
            return "https://3m7wx2g9bb.execute-api.ap-south-1.amazonaws.com/V1/generateuserotp"
        case .resendOTP:
            return "https://3m7wx2g9bb.execute-api.ap-south-1.amazonaws.com/V1/resenduserotp"
        case .validateUser:
            return "https://3m7wx2g9bb.execute-api.ap-south-1.amazonaws.com/V1/validateuser"
        }
    }
}
