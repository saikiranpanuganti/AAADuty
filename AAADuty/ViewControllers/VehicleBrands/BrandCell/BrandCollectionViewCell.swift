//
//  BrandCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit
import SDWebImage

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    var vehicleBrand: VechicleBrand?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 10
        roundedView.layer.masksToBounds = true
    }

    func configureUI(vehicleBrand: VechicleBrand?) {
        imageOutlet.sd_setImage(with: URL(string: vehicleBrand?.imageURL ?? ""))
        if vehicleBrand?.isSelected ?? false {
            brandSelected()
        }else {
            brandUnSelected()
        }
    }
    
    func brandSelected() {
        roundedView.layer.borderColor = UIColor(red: 1, green: 127/255, blue: 0, alpha: 1).cgColor
        roundedView.layer.borderWidth = 2
    }
    
    func brandUnSelected() {
        roundedView.layer.borderColor = UIColor.clear.cgColor
        roundedView.layer.borderWidth = 0
    }
}
