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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tickView: UIView!

    var subCategoryType: SubCategoryType?
    var complaintType: ComplaintType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tickView.isHidden = true
    }

    func configureUI(subCategoryType: SubCategoryType?) {
        self.subCategoryType = subCategoryType
        colorView.backgroundColor = subCategoryType?.color
        imageOutlet.sd_setImage(with: URL(string: subCategoryType?.imageURL ?? ""))
        nameOutlet.text = subCategoryType?.subCategoryName
        
        if subCategoryType?.isSelected ?? false {
            bottomView.isHidden = false
        }else {
            bottomView.isHidden = true
        }
        
        if subCategoryType?.isAdded ?? false {
            tickView.isHidden = false
        }else {
            tickView.isHidden = true
        }
    }
    
    func configureUI(complaintType: ComplaintType?) {
        self.complaintType = complaintType
        colorView.backgroundColor = complaintType?.color
        imageOutlet.sd_setImage(with: URL(string: complaintType?.imageURL ?? ""))
        nameOutlet.text = complaintType?.complaint
        bottomView.isHidden = true
        
        if complaintType?.isSelected ?? false {
            tickView.isHidden = false
        }else {
            tickView.isHidden = true
        }
    }
}
