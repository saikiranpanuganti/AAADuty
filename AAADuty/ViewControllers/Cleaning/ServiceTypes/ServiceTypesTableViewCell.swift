//
//  ServiceTypesTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 18/03/23.
//

import UIKit

protocol ServiceTypesTableViewCellDelegate: AnyObject {
    func subCategoryTypeTapped(subCategoryType: SubCategoryType?)
}

class ServiceTypesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ServiceTypesTableViewCellDelegate?
    var subCategoryTypes: [SubCategoryType]?

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
    
    func setSelectedSubCategoryType(indexPath: IndexPath) {
        for index in 0..<(subCategoryTypes?.count ?? 0) {
            if index == indexPath.row {
                subCategoryTypes?[index].isSelected = true
            }else {
                subCategoryTypes?[index].isSelected = false
            }
        }
    }
}

extension ServiceTypesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategoryTypes?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceTypeCollectionViewCell", for: indexPath) as? ServiceTypeCollectionViewCell {
            cell.configureUI(subCategoryType: subCategoryTypes?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
extension ServiceTypesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectedSubCategoryType(indexPath: indexPath)
        updateUI()
        delegate?.subCategoryTypeTapped(subCategoryType: subCategoryTypes?[indexPath.row])
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
