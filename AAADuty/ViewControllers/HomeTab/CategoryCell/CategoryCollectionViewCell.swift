//
//  CategoryCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: AAAView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: AAALabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureUI(category: Category) {
        imageOutlet.sd_setImage(with: URL(string: category.requestImageURL ?? ""))
        titleOutlet.text = category.category
        roundedView.backgroundColor = category.colorCode?.hexStringToUIColor()
    }
}
