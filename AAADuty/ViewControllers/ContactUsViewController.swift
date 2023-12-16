//
//  ContactUsViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 16/12/23.
//

import UIKit

class ContactUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func firstNumberTapped() {
        let numberString = "8977525397"
        guard let url = URL(string: "telprompt://\(numberString)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func secondNumberTapped() {
        let numberString = "8977525398"
        guard let url = URL(string: "telprompt://\(numberString)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
