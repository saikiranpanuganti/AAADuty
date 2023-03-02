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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI() {
        
    }
}
