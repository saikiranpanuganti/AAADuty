//
//  BaseViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

class BaseViewController: UIViewController {
    var loader: UIAlertController?
    let sideMenuView = SideMenuView.instanceFromNib()
    var sideMenuIsHidden: Bool = true
    var sideMenuLeftAnchor: NSLayoutConstraint?
    var sideMenuAvailable: Bool = false {
        didSet {
            if sideMenuAvailable {
                addSideMenuView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
    
    func getLoader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
        return alert
    }
    
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loader?.dismiss(animated: false, completion: nil)
            self?.loader = nil
            self?.loader = self?.getLoader()
        }
    }
        
    func stopLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loader?.dismiss(animated: true, completion: nil)
            self?.loader = nil
        }
    }
    
    func stopLoader(_ completion: @escaping (() -> ())) {
        DispatchQueue.main.async { [weak self] in
            self?.loader?.dismiss(animated: true, completion: completion)
            self?.loader = nil
        }
    }
    
    func showAlert(title: String, message: String) { //, completion: (() -> ())
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String, completion: @escaping (() -> ())) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                completion()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func logoutUser() {
        
    }
    
    func handleSideMenuTap(menuType: MenuType) {
        
    }
}


extension BaseViewController: SideMenuViewDelegate {
    func hideSideMenu() {
        showHideSideMenu()
    }
    
    func sideMenuItemTapped(menuType: MenuType) {
        if menuType == .logout {
            logoutUser()
        }else {
            handleSideMenuTap(menuType: menuType)
        }
    }
}
