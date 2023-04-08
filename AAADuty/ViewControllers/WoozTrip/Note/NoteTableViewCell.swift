//
//  NoteTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 17/03/23.
//

import UIKit

protocol NoteTableViewCellDelegate: AnyObject {
    func noteCloseTapped()
}

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    
    weak var delegate: NoteTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 18
        roundedView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        roundedView.layer.borderWidth = 1.5
        roundedView.layer.masksToBounds = true
    }
    
    func configureUI(note: String) {
        noteLabel.text = note
    }

    @IBAction func closeTapped() {
        delegate?.noteCloseTapped()
    }
}
