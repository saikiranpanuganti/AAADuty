//
//  SearchTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 09/03/23.
//

import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    func searchTapped()
    func vehicleSelected(vehicle: Vechicle?)
}

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfieldOutlet: UITextField!
    
    weak var delegate: SearchTableViewCellDelegate?
    
    var vehicles: VechiclesModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureUI(vehicles: VechiclesModel?) {
        self.vehicles = vehicles
        tableView.reloadData()
    }
    
    func updateText(text: String?) {
        textfieldOutlet.text = text
    }
    
    @IBAction func searchTapped() {
        delegate?.searchTapped()
    }
}


extension SearchTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles?.response?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell {
            cell.configureUI(vechicle: vehicles?.response?[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
extension SearchTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateText(text: vehicles?.response?[indexPath.row].vehicleName)
        delegate?.vehicleSelected(vehicle: vehicles?.response?[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
