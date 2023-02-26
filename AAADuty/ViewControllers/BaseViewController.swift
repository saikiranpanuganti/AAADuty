//
//  BaseViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

class BaseViewController: UIViewController {

    let sideMenuView = SideMenuView.instanceFromNib()
    var sideMenuIsHidden: Bool = true
    var sideMenuLeftAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSideMenuView()
    }
    
    func addSideMenuView() {
        view.addSubview(sideMenuView)
        sideMenuView.delegate = self
        
        sideMenuView.translatesAutoresizingMaskIntoConstraints = false
        sideMenuLeftAnchor = sideMenuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -sideMenuWidth)
        sideMenuLeftAnchor?.isActive = true
        sideMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: sideMenuWidth).isActive = true
    }
    
    func showHideSideMenu() {
        if sideMenuIsHidden {
            sideMenuLeftAnchor?.constant = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            } completion: { bool in
                self.sideMenuIsHidden = false
                self.sideMenuView.setBackground(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.37))
            }
        }else {
            self.sideMenuView.setBackground(color: UIColor.clear)
            sideMenuLeftAnchor?.constant = -sideMenuWidth
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            } completion: { bool in
                self.sideMenuIsHidden = true
            }
        }
    }
}


extension BaseViewController: SideMenuViewDelegate {
    func hideSideMenu() {
        showHideSideMenu()
    }
}
