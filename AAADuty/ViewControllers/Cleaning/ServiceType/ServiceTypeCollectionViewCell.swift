//
//  ServiceTypeCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

class ServiceTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!

    var subCategoryType: SubCategoryType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func configureUI(subCategoryType: SubCategoryType?) {
        self.subCategoryType = subCategoryType
        colorView.backgroundColor = subCategoryType?.color
        imageOutlet.sd_setImage(with: URL(string: subCategoryType?.imageURL ?? ""))
        nameOutlet.text = subCategoryType?.subCategoryName
        
        if subCategoryType?.isSelected ?? false {
            backView.layer.borderColor = UIColor(named: "orangeAppColor")?.cgColor
            backView.layer.borderWidth = 2
            backView.layer.cornerRadius = 10
            backView.layer.masksToBounds = true
        }else {
            backView.layer.borderColor = UIColor.clear.cgColor
            backView.layer.borderWidth = 2
        }
    }
}
