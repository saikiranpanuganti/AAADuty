//
//  RequestAcceptedViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/03/23.
//

import UIKit

class RequestAcceptedViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.layer.cornerRadius = doneButton.frame.height/2
        doneButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        doneButton.layer.shadowOpacity = 1
        doneButton.layer.shadowOffset = .zero
        doneButton.layer.shadowRadius = 5
    }

    @IBAction func doneTapped() {
        
    }
}
