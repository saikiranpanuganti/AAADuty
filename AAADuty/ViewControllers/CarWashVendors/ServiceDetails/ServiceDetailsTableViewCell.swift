//
//  ServiceDetailsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 10/03/23.
//

import UIKit

class ServiceDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var servicename: UILabel!
    @IBOutlet weak var subServiceDescription: UILabel!
    
    var category: Category?
    var subCategory: SubCategoryModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureUI(category: Category?, subCategory: SubCategoryModel?, subTitle: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.subCategory = subCategory
            self.servicename.text = category?.category
            self.serviceIcon.sd_setImage(with: URL(string: category?.requestImageURL ?? ""))
            self.subServiceDescription.text = subTitle
        }
    }
}
