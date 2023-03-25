//
//  ServiceTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/03/23.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var servicename: UILabel!
    
    var category: Category?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(category: Category?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.servicename.text = category?.category
            self.serviceIcon.sd_setImage(with: URL(string: category?.requestImageURL ?? ""))
        }
    }
    
}
