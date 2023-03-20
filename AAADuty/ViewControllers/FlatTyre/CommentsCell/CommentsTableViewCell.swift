//
//  CommentsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 03/03/23.
//

import UIKit

protocol CommentsTableViewCellDelegate: AnyObject {
    func commentsEntered(comments: String?)
}

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var textfieldOutlet: UITextField!
    
    weak var delegate: CommentsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textfieldOutlet.delegate = self
    }

    
}


extension CommentsTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.commentsEntered(comments: textField.text)
    }
}
