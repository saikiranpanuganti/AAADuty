//
//  OrderDetailsHeaderTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 19/03/23.
//

import UIKit

protocol OrderDetailsHeaderTableViewCellDelegate: AnyObject {
    func editTapped()
}

class OrderDetailsHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    
    weak var delegate: OrderDetailsHeaderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(category: Category?) {
        if let category = category {
            serviceName.text = category.category
            serviceIcon.sd_setImage(with: URL(string: category.requestImageURL ?? ""))
        }
    }

    @IBAction func editTapped() {
        delegate?.editTapped()
    }
    
}
