//
//  SideMenuView.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

class SideMenuView: UIView {
    @IBOutlet weak var menuTableView: UITableView!
    
    class func instanceFromNib() -> SideMenuView {
        return UINib(nibName: "SideMenuView", bundle: Bundle(for: self)).instantiate(withOwner: nil, options: nil)[0] as! SideMenuView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        print("Sidemenu topSafeAreaHeight \(topSafeAreaHeight)")
    }

}

extension SideMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = menuTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240 + topSafeAreaHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension SideMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
