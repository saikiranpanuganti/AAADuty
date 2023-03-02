//
//  SubCategoryCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 02/03/23.
//

import UIKit

class SubCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: AAAView!
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var subCategoryName: AAALabel!
    
    var subCat: SubCategory?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureUI(subCategory: SubCategory?) {
        subCat = subCategory
        if subCategory?.isSelected ?? false {
            subCategorySelected()
        }else {
            subCategoryUnSelected()
        }
    }
    
    func subCategorySelected() {
        roundedView.layer.borderColor = UIColor(red: 1, green: 127/255, blue: 0, alpha: 1).cgColor
        roundedView.layer.borderWidth = 1
    }
    
    func subCategoryUnSelected() {
        roundedView.layer.borderColor = UIColor.clear.cgColor
        roundedView.layer.borderWidth = 0
    }
}
