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
    @IBOutlet weak var addView: UIView!

    weak var delegate: CleaningServiceTableViewCellDelegate?
    var cleaningService: CleaningService?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        plusMinusView.isHidden = true
        
        addView.layer.cornerRadius = 18
        addView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        addView.layer.shadowOpacity = 1
        addView.layer.shadowOffset = .zero
        addView.layer.shadowRadius = 5
        
        plusMinusView.layer.cornerRadius = 18
        plusMinusView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        plusMinusView.layer.shadowOpacity = 1
        plusMinusView.layer.shadowOffset = .zero
        plusMinusView.layer.shadowRadius = 5
        
        imageOutlet.layer.borderColor = UIColor(red: 18/255, green: 69/255, blue: 115/255, alpha: 1).cgColor
        imageOutlet.layer.borderWidth = 1
        imageOutlet.layer.cornerRadius = 20
        imageOutlet.layer.masksToBounds = true
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
