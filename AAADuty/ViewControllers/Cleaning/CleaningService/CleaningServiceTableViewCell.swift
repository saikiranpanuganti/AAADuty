//
//  CleaningServiceTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

protocol CleaningServiceTableViewCellDelegate: AnyObject {
    func countChanged(cleaningService: CleaningService?, count: Int)
}

class CleaningServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var countOutlet: UILabel!

    weak var delegate: CleaningServiceTableViewCellDelegate?
    var cleaningService: CleaningService?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        plusMinusView.isHidden = true
    }
    
    func configureUI(cleaningService: CleaningService?) {
        self.cleaningService = cleaningService
        imageOutlet.sd_setImage(with: URL(string: cleaningService?.imageURL ?? ""))
        titleOutlet.text = cleaningService?.serviceName
        descriptionOutlet.text = cleaningService?.description
        if (cleaningService?.count ?? 0) > 0 {
            plusMinusView.isHidden = false
        }else {
            plusMinusView.isHidden = true
        }
        countOutlet.text = "\(cleaningService?.count ?? 0)"
    }
    
    @IBAction func addButtonTapped() {
        plusMinusView.isHidden = false
        countOutlet.text = "1"
        cleaningService?.count = 1
        delegate?.countChanged(cleaningService: cleaningService, count: 1)
    }
    
    @IBAction func minusButtonTapped() {
        if let count = cleaningService?.count {
            if count > 1 {
                cleaningService?.count = count - 1
            }else {
                cleaningService?.count = 0
                plusMinusView.isHidden = true
            }
            countOutlet.text = "\(count - 1)"
            delegate?.countChanged(cleaningService: cleaningService, count: count - 1)
        }
    }
    
    @IBAction func plusButtonTapped() {
        if let count = cleaningService?.count {
            cleaningService?.count = count + 1
            countOutlet.text = "\(count + 1)"
            delegate?.countChanged(cleaningService: cleaningService, count: count + 1)
        }
    }
}
