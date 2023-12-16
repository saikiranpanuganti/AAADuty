//
//  SideMenuView.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

enum MenuType {
    case orderHistory
    case transactions
    case myProfile
    case rateUs
    case contact
    case logout
}

struct MenuItem {
    var icon: String
    var title: String
    var type: MenuType
}

import UIKit

protocol SideMenuViewDelegate: AnyObject {
    func hideSideMenu()
    func handleLogout()
    func sideMenuItemTapped(menuType: MenuType)
    func profileTapped()
}

extension SideMenuViewDelegate {
    func hideSideMenu() {  }
    func handleLogout() {  }
}


class SideMenuView: UIView {
    @IBOutlet weak var menuTableView: UITableView!
    
    weak var delegate: SideMenuViewDelegate?
    var menu: [MenuItem] = [MenuItem(icon: "users", title: "Order History", type: .orderHistory), MenuItem(icon: "history", title: "Transactions", type: .transactions), MenuItem(icon: "recent", title: "My Profile", type: .myProfile), MenuItem(icon: "history", title: "Contact", type: .contact), MenuItem(icon: "recent", title: "Logout", type: .logout)]
//    MenuItem(icon: "users", title: "Rate Us", type: .rateUs)
    
    class func instanceFromNib() -> SideMenuView {
        return UINib(nibName: "SideMenuView", bundle: Bundle(for: self)).instantiate(withOwner: nil, options: nil)[0] as! SideMenuView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognised))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    func setBackground(color: UIColor) {
        backgroundColor = color
    }

    @objc func tapGestureRecognised() {
        delegate?.hideSideMenu()
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
            return menu.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = menuTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
                cell.updateProfile()
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
        if indexPath.section == 0 {
            delegate?.profileTapped()
        }else if indexPath.section == 1 {
            delegate?.sideMenuItemTapped(menuType: menu[indexPath.row].type)
        }
    }
}


extension SideMenuView: UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: menuTableView) == true {
            return false
        }
        return true
    }
}
 
