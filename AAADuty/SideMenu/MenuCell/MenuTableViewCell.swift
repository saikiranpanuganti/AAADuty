//
//  MenuTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var iconOutlet: UIImageView!
    @IBOutlet weak var itemLabel: AAALabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(menuItem: MenuItem) {
        iconOutlet.image = UIImage(named: menuItem.icon)
        itemLabel.text = menuItem.title
    }
    
}
