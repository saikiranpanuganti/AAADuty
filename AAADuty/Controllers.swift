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
//        case .tabBar:
//            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
//        case .account:
//            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController")
//        case .settings:
//            return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
//        case .player:
//            return UIStoryboard(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController")
        }
    }
}
