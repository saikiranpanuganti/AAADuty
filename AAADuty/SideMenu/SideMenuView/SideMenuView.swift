//
//  SideMenuView.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

struct MenuItem {
    var icon: String
    var title: String
}

import UIKit

class SideMenuView: UIView {
    @IBOutlet weak var menuTableView: UITableView!
    
    var menu: [MenuItem] = [MenuItem(icon: "users", title: "Order History"), MenuItem(icon: "history", title: "Transactions"), MenuItem(icon: "recent", title: "My Profile"), MenuItem(icon: "users", title: "Rate Us"), MenuItem(icon: "history", title: "Contact"), MenuItem(icon: "recent", title: "Logout")]
    
    class func instanceFromNib() -> SideMenuView {
        return UINib(nibName: "SideMenuView", bundle: Bundle(for: self)).instantiate(withOwner: nil, options: nil)[0] as! SideMenuView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
    }

}

extension SideMenuView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = menuTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
                cell.configureUI(menuItem: menu[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220 + topSafeAreaHeight
        }else if indexPath.section == 1 {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return " "
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension SideMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
