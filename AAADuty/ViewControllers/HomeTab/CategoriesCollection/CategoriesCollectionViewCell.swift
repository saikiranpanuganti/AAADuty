//
//  CategoriesCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

protocol CategoriesCollectionViewCellDelegate: AnyObject {
    func categoryTapped(category: Category)
}

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    weak var delegate: CategoriesCollectionViewCellDelegate?
    var categories: [Category] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 30
        roundedView.layer.masksToBounds = true
        
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        categoriesCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }

    func configureUI(categoriesArray: [Category]) {
        categories = categoriesArray
        
        DispatchQueue.main.async { [weak self] in
            self?.categoriesCollectionView.reloadData()
        }
    }
}

extension CategoriesCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell {
            cell.configureUI(category: categories[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CategoriesCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryTapped(category: categories[indexPath.row])
    }
}

extension CategoriesCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (categoriesCollectionView.frame.width - 120)/3, height: (categoriesCollectionView.frame.width + 10)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

