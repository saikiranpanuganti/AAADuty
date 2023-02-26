//
//  AppData.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import Foundation

class AppData {
    private init() {  }
    
    static let shared: AppData = AppData()
    
    var categories: [Category] = []
    var user: User?
    
    var isLogged: Bool {
        if user == nil {
            
        }
        return user != nil
    }
}
