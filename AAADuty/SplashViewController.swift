//
//  SplashViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.pushViewController(Controllers.tabBar.getController(), animated: true)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let top = view.safeAreaInsets.top
        topSafeAreaHeight = top
        
        let bottom = view.safeAreaInsets.bottom
        bottomSafeAreaHeight = bottom
    }

}
