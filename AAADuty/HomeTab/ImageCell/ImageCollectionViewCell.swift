//
//  ImageCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageOutlet: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureUI(imageName: String) {
        imageOutlet.image = UIImage(named: imageName)
    }
}
