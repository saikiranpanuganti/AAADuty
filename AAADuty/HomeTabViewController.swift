//
//  HomeTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

class HomeTabViewController: UIViewController {
    
    let sideMenuView = SideMenuView.instanceFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSideMenuView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func addSideMenuView() {
        view.addSubview(sideMenuView)
//        sideMenuView.isHidden = true
        print("Sidemenu width \(sideMenuWidth)")
        sideMenuView.translatesAutoresizingMaskIntoConstraints = false
        sideMenuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        sideMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: sideMenuWidth).isActive = true
        
        print("Sidemenu width \(sideMenuView.frame.width)")
    }

}
