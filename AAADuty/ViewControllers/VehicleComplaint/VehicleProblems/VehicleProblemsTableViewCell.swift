//
//  VehicleProblemsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

protocol VehicleProblemsTableViewCellDelegate: AnyObject {
    func vehicleProblemSelected(vehicleProblem: VechicleProblem?)
    func searchTapped()
}

class VehicleProblemsTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var servicename: UILabel!
    @IBOutlet weak var subServiceDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfieldOutlet: UITextField!
    
    weak var delegate: VehicleProblemsTableViewCellDelegate?
    
    var category: Category?
    var vehicleProblems: VechicleProblemModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureUI(category: Category?, vehicleProblems: VechicleProblemModel?) {
        updateText(text: "")
        self.vehicleProblems = vehicleProblems
        self.category = category
        self.servicename.text = category?.category
        self.serviceIcon.sd_setImage(with: URL(string: category?.requestImageURL ?? ""))
        self.subServiceDescription.text = category?.subCategoryMessage
        tableView.reloadData()
    }
    
    func updateText(text: String?) {
        textfieldOutlet.text = text
    }
    
    @IBAction func searchTapped() {
        delegate?.searchTapped()
    }
}


extension VehicleProblemsTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleProblems?.response?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell {
            cell.configureUI(vechicleProblem: vehicleProblems?.response?[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
extension VehicleProblemsTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateText(text: vehicleProblems?.response?[indexPath.row].problem)
        delegate?.vehicleProblemSelected(vehicleProblem: vehicleProblems?.response?[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
