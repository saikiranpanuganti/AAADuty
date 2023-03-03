//
//  SubServicesTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 02/03/23.
//

import UIKit
import SDWebImage

protocol SubServicesTableViewCellDelegate: AnyObject {
    func subServiceTapped(subCategory: SubCategory?)
}

class SubServicesTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var servicename: AAALabel!
    @IBOutlet weak var subServiceDescription: AAALabel!
    @IBOutlet weak var subServiceCollectionView: UICollectionView!

    weak var delegate: SubServicesTableViewCellDelegate?
    
    var category: Category?
    var subCategory: SubCategoryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subServiceCollectionView.register(UINib(nibName: "SubCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCollectionViewCell")
        subServiceCollectionView.dataSource = self
        subServiceCollectionView.delegate = self
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.subServiceCollectionView.reloadData()
        }
    }

    func configureUI(category: Category?, subCategory: SubCategoryModel?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.subCategory = subCategory
            self.servicename.text = category?.category
            self.serviceIcon.sd_setImage(with: URL(string: category?.requestImageURL ?? ""))
            self.subServiceDescription.text = category?.subCategoryMessage
            self.subServiceCollectionView.reloadData()
        }
    }
    
    func setSelectedSubCategory(indexPath: IndexPath) {
        for index in 0..<(subCategory?.categories?.count ?? 0) {
            if index == indexPath.row {
                subCategory?.categories?[index].isSelected = true
            }else {
                subCategory?.categories?[index].isSelected = false
            }
        }
    }
}


extension SubServicesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategory?.categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = subServiceCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as? SubCategoryCollectionViewCell {
            cell.configureUI(subCategory: subCategory?.categories?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SubServicesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectedSubCategory(indexPath: indexPath)
        updateCollectionView()
        delegate?.subServiceTapped(subCategory: subCategory?.categories?[indexPath.row])
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
