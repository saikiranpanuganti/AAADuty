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
        // Initialization code
    }

    func configureUI() {
        imageOutlet.image = UIImage(named: "dummyCategory")
        titleOutlet.text = "Pest Control"
    }
}
