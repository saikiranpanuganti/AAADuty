//
//  UrlHandler.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//


import Foundation

enum Url {
    case categories
    
    func getUrl() -> String {
        switch self {
        case .categories:
            return "https://3m7wx2g9bb.execute-api.ap-south-1.amazonaws.com/V1/getcategories"
        }
    }
}
