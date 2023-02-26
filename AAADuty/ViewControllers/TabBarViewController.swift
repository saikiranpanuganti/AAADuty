//
//  TabBarViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

class CustomTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 95
        return sizeThatFits
    }
}

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        tabBar.tintColor = UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1)//UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        tabBar.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)], for: .normal)
        
        tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOpacity = 1
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTabBarSelection()
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      updateTabBarSelection()
  }

  func updateTabBarSelection() {
      let normalFont = UIFont.systemFont(ofSize: 14)
      let selectedFont = UIFont.boldSystemFont(ofSize: 14)
      viewControllers?.forEach {
          if let homeVC = $0 as? HomeTabViewController {
              homeVC.delegate = self
          }
          let selected = $0 == self.selectedViewController
          $0.tabBarItem.setTitleTextAttributes([.font: selected ? selectedFont : normalFont], for: .normal)
      }
  }
}


extension TabBarViewController: HomeTabViewControllerDelegate {
    func navigateToStart() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.viewControllers = [Controllers.welcome.getController()]
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
