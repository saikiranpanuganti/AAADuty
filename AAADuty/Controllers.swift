//
//  Controllers.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

enum Controllers {
    case welcome
    case login
    case otpVc
    case tabBar
    case homeTab
    case profileTab
    case walletTab
    case bookingsTab
    case flatTyre
    case orderConfirmation
    case paymentModes
    case towing
    case maps
    case requestAccepted
    case requestStatus
    case vechicleTech
    case vehicleBrands
    case vehicleComplaint
    case carWashVendors
    case carWashDetails
    case wooz
    case woozTrip
    case woozTripDetails
    case cleaning
    case cleaningSelection
    case cleaningOrderDetails
    case gasTechnician
    
    func getController() -> UIViewController {
        switch self {
        case .welcome:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
        case .login:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MobileLoginViewController")
        case .otpVc:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController")
        case .tabBar:
            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
        case .homeTab:
            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "HomeTabViewController")
        case .profileTab:
            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ProfileTabViewController")
        case .walletTab:
            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "WalletTabViewController")
        case .bookingsTab:
            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "BookingsTabViewController")
        case .flatTyre:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "FlatTyreViewController")
        case .orderConfirmation:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "OrderConfirmationViewController")
        case .paymentModes:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "PaymentModesViewController")
        case .towing:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "TowingViewController")
        case .maps:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "MapsViewController")
        case .requestAccepted:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "RequestAcceptedViewController")
        case .requestStatus:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "StatusViewController")
        case .vechicleTech:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "VechicleTechnicianViewController")
        case .vehicleBrands:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "VehicleBrandsViewController")
        case .vehicleComplaint:
            return UIStoryboard(name: "Services", bundle: nil).instantiateViewController(withIdentifier: "VehicleComplaintViewController")
        case .carWashVendors:
            return UIStoryboard(name: "VehicleServices", bundle: nil).instantiateViewController(withIdentifier: "CarWashVendorsViewController")
        case .carWashDetails:
            return UIStoryboard(name: "VehicleServices", bundle: nil).instantiateViewController(withIdentifier: "CarWashDetailsViewController")
        case .wooz:
            return UIStoryboard(name: "VehicleServices", bundle: nil).instantiateViewController(withIdentifier: "WoozViewController")
        case .woozTrip:
            return UIStoryboard(name: "VehicleServices", bundle: nil).instantiateViewController(withIdentifier: "WoozTripViewController")
        case .woozTripDetails:
            return UIStoryboard(name: "VehicleServices", bundle: nil).instantiateViewController(withIdentifier: "WoozTripDetailsViewController")
        case .cleaning:
            return UIStoryboard(name: "Cleaning", bundle: nil).instantiateViewController(withIdentifier: "CleaningViewController")
        case .cleaningSelection:
            return UIStoryboard(name: "Cleaning", bundle: nil).instantiateViewController(withIdentifier: "CleaningSelectionViewController")
        case .cleaningOrderDetails:
            return UIStoryboard(name: "Cleaning", bundle: nil).instantiateViewController(withIdentifier: "CleaningOrderDetailsViewController")
        case .gasTechnician:
            return UIStoryboard(name: "GasTechnician", bundle: nil).instantiateViewController(withIdentifier: "GasTechnicianViewController")
//        case .player:
//            return UIStoryboard(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController")
//        case .player:
//            return UIStoryboard(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController")
//        case .player:
//            return UIStoryboard(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController")
//        case .player:
//            return UIStoryboard(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController")
//        case .player:
//            return UIStoryboard(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController")
        }
    }
}
