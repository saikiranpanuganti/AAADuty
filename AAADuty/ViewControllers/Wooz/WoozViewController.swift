//
//  WoozViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 11/03/23.
//

import UIKit


class WoozViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    var subCategories: SubCategoryModel?
    var selectedSubCategory: SubCategory?
    var complaintTypes: [ComplaintType]?
    var selectedComplaintType: ComplaintType?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        tableView.register(UINib(nibName: "SubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServicesTableViewCell")
        tableView.register(UINib(nibName: "ContinueTableViewCell", bundle: nil), forCellReuseIdentifier: "ContinueTableViewCell")
        tableView.register(UINib(nibName: "TransitionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransitionTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getSubCategories()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setSelectedSubCategory()
            self.tableView.reloadData()
        }
    }
    
    func setSelectedSubCategory() {
        if selectedSubCategory != nil {
            for (index, category) in (subCategories?.categories ?? []).enumerated() {
                if category.id == selectedSubCategory?.id {
                    subCategories?.categories?[index].isSelected = true
                }else {
                    subCategories?.categories?[index].isSelected = false
                }
            }
        }
    }
    
    func getSubCategories() {
        if let categoryId = category?.id {
            showLoader()
            let bodyParams: [String: Any] = ["CategoryID": categoryId]
            print("Url - \(Url.getTypes.getUrl())")
            print("Body Params - \(bodyParams)")
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
    
    func getComplaintType(categoryId: String?, typeID: String?) {
        if let categoryId = categoryId, let typeID = typeID {
            showLoader()
            
            let bodyParams: [String: Any] = ["CategoryID": categoryId, "TypeID": typeID]
            print("Body Params - \(bodyParams)")
            NetworkAdaptor.requestWithHeaders(urlString: Url.getComplaintTypes.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
                guard let self = self else { return }
                self.stopLoader()
                
                if let data = data {
                    do {
                        let complaintTypeModel = try JSONDecoder().decode(ComplaintTypeModel.self, from: data)
                        self.complaintTypes = complaintTypeModel.complaintTypes
                        self.updateUI()
                    }catch {
                        print("Error: FlatTyreViewController getComplaintType - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

extension WoozViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedSubCategory == nil && selectedComplaintType == nil {
            return 2
        }else if selectedSubCategory != nil && selectedComplaintType == nil {
            return 3
        }
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell {
                cell.delegate = self
                cell.configureUI(title: category?.categoryTitle)
                return cell
            }
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SubServicesTableViewCell", for: indexPath) as? SubServicesTableViewCell {
                cell.delegate = self
                cell.configureUI(category: category, subCategory: subCategories)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TransitionTableViewCell", for: indexPath) as? TransitionTableViewCell {
                cell.delegate = self
                cell.configureUI(complaintTypes: complaintTypes)
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueTableViewCell", for: indexPath) as? ContinueTableViewCell {
                cell.title = "NEXT"
                cell.font = UIFont(name: "Segoe-UI-SemiBold", size: 18)
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
}
extension WoozViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else if indexPath.section == 1 {
            let rows: Int = (((subCategories?.categories?.count ?? 0)/3) + ((((subCategories?.categories?.count ?? 0) % 3) == 0) ? 0 : 1))
            return 170 + (((screenWidth)/3)*CGFloat(rows))
        }
        return UITableView.automaticDimension
    }
}


extension WoozViewController: LocationTableViewCellDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


extension WoozViewController: SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {
        if selectedSubCategory?.id != subCategory?.id {
            selectedSubCategory = subCategory
            getComplaintType(categoryId: selectedSubCategory?.categoryID, typeID: selectedSubCategory?.id)
        }
    }
}


extension WoozViewController: ContinueTableViewCellDelegate {
    func continueTapped() {
        
    }
}


extension WoozViewController: TransitionTableViewCellDelegate {
    func transitionTapped(complaintType: ComplaintType?) {
        selectedComplaintType = complaintType
        tableView.reloadData()
    }
}
