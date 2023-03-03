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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "CountTableViewCell", bundle: nil), forCellReuseIdentifier: "CountTableViewCell")
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
    
}

extension FlatTyreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
                cell.configureUI()
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
        }else if indexPath.section == 1 || indexPath.section == 2 {
            return UITableView.automaticDimension
        }
        return 0
    }
}


extension FlatTyreViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
