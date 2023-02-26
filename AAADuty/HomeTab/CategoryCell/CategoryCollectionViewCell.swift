//
//  CategoryCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: AAALabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageOutlet.layer.cornerRadius = 20
        imageOutlet.layer.masksToBounds = true
    }

    func configureUI(category: Category) {
//        imageOutlet.image = UIImage(named: "dummyCategory")
        titleOutlet.text = category.category
        imageOutlet.backgroundColor = category.colorCode?.hexStringToUIColor()
    }
}
