//
//  FlatTyreViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 28/02/23.
//

import UIKit

class FlatTyreViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var count: Int = 0
    var price: Double = 10
    var amount: Double {
        return Double(count)*price
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "CountTableViewCell", bundle: nil), forCellReuseIdentifier: "CountTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.register(UINib(nibName: "LocationSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationSelectionTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getSubCategories()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func getSubCategories() {
        if let categoryId = category?.id {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId]
            NetworkAdaptor.requestWithHeaders(urlString: Url.getTypes.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let subCategoryModel = try JSONDecoder().decode(SubCategoryModel.self, from: data)
                        self.subCategories = subCategoryModel
                        self.updateUI()
                    }catch {
                        print("Error: FlatTyreViewController getSubCategories - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func updateCountCell() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let countCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? CountTableViewCell {
                countCell.configureUI(count: self.count, amount: self.amount)
            }
        }
    }
}

extension FlatTyreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubServicesTableViewCell", for: indexPath) as? SubServicesTableViewCell {
                cell.configureUI(category: category, subCategory: subCategories)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CountTableViewCell", for: indexPath) as? CountTableViewCell {
                cell.delegate = self
                cell.configureUI(count: count, amount: amount)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionTableViewCell", for: indexPath) as? LocationSelectionTableViewCell {
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell {
                return cell
            }
        }else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension FlatTyreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else {
            return UITableView.automaticDimension
        }
//        return 0
    }
}


extension FlatTyreViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension FlatTyreViewController: CountTableViewCellDelegate {
    func plusTapped() {
        count += 1
        updateCountCell()
    }
    func minusTapped() {
        if count > 0 {
            count -= 1
            updateCountCell()
        }
    }
}
