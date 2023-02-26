//
//  BaseViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

class BaseViewController: UIViewController {

    let sideMenuView = SideMenuView.instanceFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSideMenuView()
    }
    
    func addSideMenuView() {
        view.addSubview(sideMenuView)
        sideMenuView.isHidden = true
        
        sideMenuView.translatesAutoresizingMaskIntoConstraints = false
        sideMenuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        sideMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: sideMenuWidth).isActive = true
    }
    
    func showHideSideMenu() {
        
    }

}
