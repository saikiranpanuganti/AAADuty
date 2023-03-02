//
//  SubServicesTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 02/03/23.
//

import UIKit

class SubServicesTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var servicename: AAALabel!
    @IBOutlet weak var subServiceDescription: AAALabel!
    @IBOutlet weak var subServiceCollectionView: UICollectionView!

    var category: Category?
    var subCategory: SubCategoryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subServiceCollectionView.register(UINib(nibName: "SubCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCollectionViewCell")
        subServiceCollectionView.dataSource = self
        subServiceCollectionView.delegate = self
    }

    func configureUI(category: Category?, subCategory: SubCategoryModel?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("SubServicesTableViewCell category - \(category?.category) subCategory - \(subCategory?.categories?.count)")
            self.subCategory = subCategory
            self.subServiceDescription.text = category?.subCategoryMessage
            self.subServiceCollectionView.reloadData()
        }
    }
    
}


extension SubServicesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("SubServicesTableViewCell numberOfItemsInSection - \(subCategory?.categories?.count ?? 0)")
        return subCategory?.categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = subServiceCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as? SubCategoryCollectionViewCell {
            cell.configureUI()
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SubServicesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension SubServicesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (subServiceCollectionView.frame.width - 40)/3, height: subServiceCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
