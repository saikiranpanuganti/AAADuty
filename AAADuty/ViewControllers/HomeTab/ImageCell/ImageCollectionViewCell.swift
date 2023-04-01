//
//  ImageCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageOutlet: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureUI(imageName: String) {
        imageOutlet.image = UIImage(named: imageName)
    }
    
    func configureUI(url: String?) {
        imageOutlet.contentMode = .scaleToFill
        imageOutlet.sd_setImage(with: URL(string: url ?? ""))
    }
}
