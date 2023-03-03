//
//  MakePaymentView.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 04/03/23.
//

import UIKit

protocol MakePaymentViewDelegate: AnyObject {
    func makePaymentTapped()
}

class MakePaymentView: UIView {
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var makePaymentButton: UIButton!
    
    weak var delegate: MakePaymentViewDelegate?
    
    class func instanceFromNib() -> MakePaymentView {
        return UINib(nibName: "MakePaymentView", bundle: Bundle(for: self)).instantiate(withOwner: nil, options: nil)[0] as! MakePaymentView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makePaymentButton.layer.cornerRadius = makePaymentButton.frame.height/2
        makePaymentButton.layer.masksToBounds = true
        
        amountView.layer.cornerRadius = amountView.frame.height/2
        amountView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        amountView.layer.shadowOpacity = 1
        amountView.layer.shadowOffset = .zero
        amountView.layer.shadowRadius = 5
        
        topLine.layer.cornerRadius = 4
    }
    
    func configureUI(amount: Int) {
        amountLabel.text = "\(amount)"
    }
    
    @IBAction func makePaymentTapped() {
        delegate?.makePaymentTapped()
    }
}
