//
//  SubCategoryCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 02/03/23.
//

import UIKit
import SDWebImage

class SubCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: AAAView!
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var subCategoryName: AAALabel!
    
    var subCat: SubCategory?
    var vehType: VechicleType?
    var tripType: TripType?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureUI(subCategory: SubCategory?) {
        subCat = subCategory
        subCategoryName.text = subCategory?.typeName
        subCategoryImage.sd_setImage(with: URL(string: subCategory?.imageURL ?? ""))
        if subCategory?.isSelected ?? false {
            subCategorySelected()
        }else {
            subCategoryUnSelected()
        }
    }
    
    func configureUI(vehicleType: VechicleType?) {
        vehType = vehicleType
        subCategoryName.text = vehicleType?.vehileType
        subCategoryImage.sd_setImage(with: URL(string: vehicleType?.imageURL ?? ""))
        if vehicleType?.isSelected ?? false {
            subCategorySelected()
        }else {
            subCategoryUnSelected()
        }
    }
    
    func configureUI(tripType: TripType?) {
        self.tripType = tripType
        subCategoryName.text = tripType?.name
        subCategoryImage.image = UIImage(named: tripType?.image ?? "")
        if tripType?.isSelected ?? false {
            subCategorySelected()
        }else {
            subCategoryUnSelected()
        }
    }
    
    func subCategorySelected() {
        roundedView.layer.borderColor = UIColor(red: 1, green: 127/255, blue: 0, alpha: 1).cgColor
        roundedView.layer.borderWidth = 2
    }
    
    func subCategoryUnSelected() {
        roundedView.layer.borderColor = UIColor.clear.cgColor
        roundedView.layer.borderWidth = 0
    }
}
