//
//  HomeTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

class HomeTabViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] {
        return AppData.shared.categories
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionCollectionViewCell")
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    

}

extension HomeTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath) as? PromotionCollectionViewCell {
                cell.delegate = self
                return cell
            }
        }else if indexPath.item == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell {
                cell.delegate = self
                cell.configureUI(categoriesArray: categories)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension HomeTabViewController: UICollectionViewDelegate {
    
}

extension HomeTabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width, height: promotionCellHeight)
        }else if indexPath.item == 1 {
            let rows: Int = ((categories.count/3) + (((categories.count % 3) == 0) ? 0 : 1))
            return CGSize(width: collectionView.frame.width, height: (((screenWidth + 40)*CGFloat(rows))/3) + 30)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeTabViewController: PromotionCollectionViewCellDelegate {
    func sideMenuTapped() {
        showHideSideMenu()
    }
    func notificationsTapped() {
        
    }
}

extension HomeTabViewController: CategoriesCollectionViewCellDelegate {
    func categoryTapped(category: Category) {
        
    }
}
