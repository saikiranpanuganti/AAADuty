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
    func vehicleTypeTapped(vehicleType: VechicleType?)
    func vehicleBrandTapped(vehicleBrand: VechicleBrand?)
}

extension SubServicesTableViewCellDelegate {
    func subServiceTapped(subCategory: SubCategory?) {  }
    func vehicleTypeTapped(vehicleType: VechicleType?) {  }
    func vehicleBrandTapped(vehicleBrand: VechicleBrand?) {  }
}

class SubServicesTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var servicename: AAALabel!
    @IBOutlet weak var subServiceDescription: UILabel!
    @IBOutlet weak var subServiceCollectionView: UICollectionView!

    weak var delegate: SubServicesTableViewCellDelegate?
    
    var category: Category?
    var subCategory: SubCategoryModel?
    var vehicleType: VechicleTypeModel?
    var vehicleBrand: VechicleBrandsModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subServiceCollectionView.register(UINib(nibName: "SubCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCollectionViewCell")
        subServiceCollectionView.register(UINib(nibName: "BrandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandCollectionViewCell")
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
    
    func configureUI(category: Category?, vehicleType: VechicleTypeModel?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.vehicleType = vehicleType
            self.servicename.text = category?.category
            self.serviceIcon.sd_setImage(with: URL(string: category?.requestImageURL ?? ""))
            self.subServiceDescription.text = category?.subCategorySectionMessage
            self.subServiceCollectionView.reloadData()
        }
    }
    
    func configureUI(category: Category?, vehicleBrand: VechicleBrandsModel?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.vehicleBrand = vehicleBrand
            self.servicename.text = category?.category
            self.serviceIcon.sd_setImage(with: URL(string: category?.requestImageURL ?? ""))
            
            if vehicleBrand?.response?.first?.typeID == "62bacecf4ee3da924a2d4eac" {
                self.subServiceDescription.text = "Select your Bike Brand"
            }else {
                self.subServiceDescription.text = "Select your Car Brand"
            }
            
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
    
    func setSelectedVehicleType(indexPath: IndexPath) {
        for index in 0..<(vehicleType?.response?.count ?? 0) {
            if index == indexPath.row {
                vehicleType?.response?[index].isSelected = true
            }else {
                vehicleType?.response?[index].isSelected = false
            }
        }
    }
    
    func setSelectedVehicleBrand(indexPath: IndexPath) {
        for index in 0..<(vehicleBrand?.response?.count ?? 0) {
            if index == indexPath.row {
                vehicleBrand?.response?[index].isSelected = true
            }else {
                vehicleBrand?.response?[index].isSelected = false
            }
        }
    }
}


extension SubServicesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if subCategory != nil {
            return subCategory?.categories?.count ?? 0
        }else if vehicleType != nil {
            return vehicleType?.response?.count ?? 0
        }else if vehicleBrand != nil {
            return vehicleBrand?.response?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if vehicleBrand != nil {
            if let cell = subServiceCollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionViewCell", for: indexPath) as? BrandCollectionViewCell {
                cell.configureUI(vehicleBrand: vehicleBrand?.response?[indexPath.row])
                return cell
            }
        }else {
            if let cell = subServiceCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as? SubCategoryCollectionViewCell {
                if subCategory != nil {
                    cell.configureUI(subCategory: subCategory?.categories?[indexPath.row])
                }else if vehicleType != nil {
                    cell.configureUI(vehicleType: vehicleType?.response?[indexPath.row])
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension SubServicesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if vehicleBrand != nil {
            setSelectedVehicleBrand(indexPath: indexPath)
            updateCollectionView()
            delegate?.vehicleBrandTapped(vehicleBrand: vehicleBrand?.response?[indexPath.row])
        }else {
            if subCategory != nil {
                setSelectedSubCategory(indexPath: indexPath)
                updateCollectionView()
                delegate?.subServiceTapped(subCategory: subCategory?.categories?[indexPath.row])
            }else if vehicleType != nil {
                setSelectedVehicleType(indexPath: indexPath)
                updateCollectionView()
                delegate?.vehicleTypeTapped(vehicleType: vehicleType?.response?[indexPath.row])
            }
        }
    }
}

extension SubServicesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if vehicleBrand != nil {
            return CGSize(width: (subServiceCollectionView.frame.width - 40)/3, height: (subServiceCollectionView.frame.width - 40)/3)
        }
        return CGSize(width: (subServiceCollectionView.frame.width - 40)/3, height: (screenWidth)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
