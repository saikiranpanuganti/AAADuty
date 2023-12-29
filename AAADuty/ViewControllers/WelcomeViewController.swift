//
//  WelcomeViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func proceedTapped() {
//        navigationController?.pushViewController(Controllers.login.getController(), animated: true)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigationController?.viewControllers = [Controllers.tabBar.getController()]
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
