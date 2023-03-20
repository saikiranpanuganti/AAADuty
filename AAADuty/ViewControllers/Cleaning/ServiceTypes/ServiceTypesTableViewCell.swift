//
//  ServiceTypesTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

protocol ServiceTypesTableViewCellDelegate: AnyObject {
    func subCategoryTypeTapped(subCategoryType: SubCategoryType?)
    func complaintTypeTapped(complaintType: ComplaintType?)
}
extension ServiceTypesTableViewCellDelegate {
    func complaintTypeTapped(complaintType: ComplaintType?) {  }
}

class ServiceTypesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ServiceTypesTableViewCellDelegate?
    var subCategoryTypes: [SubCategoryType]?
    var complaintTypes: [ComplaintType]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "ServiceTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceTypeCollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func configureUI(subCategoryTypes: [SubCategoryType]?, title: String) {
        self.subCategoryTypes = subCategoryTypes
        titleOutlet.text = title
        updateUI()
    }
    
    func configureUI(complaintTypes: [ComplaintType]?, title: String) {
        self.complaintTypes = complaintTypes
        titleOutlet.text = title
        updateUI()
    }
    
    func setSelectedSubCategoryType(indexPath: IndexPath) {
        for index in 0..<(subCategoryTypes?.count ?? 0) {
            if index == indexPath.row {
                subCategoryTypes?[index].isSelected = true
            }else {
                subCategoryTypes?[index].isSelected = false
            }
        }
    }
    
    func setSelectedComplaintType(indexPath: IndexPath) {
        let isSelected = complaintTypes?[indexPath.row].isSelected ?? true
        complaintTypes?[indexPath.row].isSelected = !isSelected
    }
}

extension ServiceTypesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if complaintTypes != nil {
            return complaintTypes?.count ?? 0
        }
        return subCategoryTypes?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceTypeCollectionViewCell", for: indexPath) as? ServiceTypeCollectionViewCell {
            if complaintTypes != nil {
                cell.configureUI(complaintType: complaintTypes?[indexPath.row])
            }else {
                cell.configureUI(subCategoryType: subCategoryTypes?[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
extension ServiceTypesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if complaintTypes != nil {
            setSelectedComplaintType(indexPath: indexPath)
            updateUI()
            delegate?.complaintTypeTapped(complaintType: complaintTypes?[indexPath.row])
        }else {
            setSelectedSubCategoryType(indexPath: indexPath)
            updateUI()
            delegate?.subCategoryTypeTapped(subCategoryType: subCategoryTypes?[indexPath.row])
        }
    }
}
extension ServiceTypesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.frame.width - 300)/2
    }
}
