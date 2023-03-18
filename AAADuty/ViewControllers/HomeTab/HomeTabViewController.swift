//
//  HomeTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

protocol HomeTabViewControllerDelegate: AnyObject {
    func navigateToStart()
}

class HomeTabViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HomeTabViewControllerDelegate?
    
    var categories: [Category] {
        return AppData.shared.categories
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuAvailable = true
        
        collectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionCollectionViewCell")
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func logoutUser() {
        AppData.shared.user?.removeUser()
        AppData.shared.user = nil
        
        delegate?.navigateToStart()
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
            return CGSize(width: collectionView.frame.width, height: (((screenWidth + 40)*CGFloat(rows))/3))
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
        if category.serviceType == .flatTyre {
            if let flatTyreVC = Controllers.flatTyre.getController() as? FlatTyreViewController {
                flatTyreVC.category = category
                navigationController?.pushViewController(flatTyreVC, animated: true)
            }
        }else if category.serviceType == .towing || category.serviceType == .carWash {
            if let towingVC = Controllers.towing.getController() as? TowingViewController {
                towingVC.category = category
                navigationController?.pushViewController(towingVC, animated: true)
            }
        }else if category.serviceType == .vechicletech {
            if let vechTechVC = Controllers.vechicleTech.getController() as? VechicleTechnicianViewController {
                vechTechVC.category = category
                vechTechVC.vechicleTypeSelection = true
                navigationController?.pushViewController(vechTechVC, animated: true)
            }
        }else if category.serviceType == .wrooz {
            if let woozVC = Controllers.wooz.getController() as? WoozViewController {
                woozVC.category = category
                navigationController?.pushViewController(woozVC, animated: true)
            }
        }else if category.serviceType == .cleaning {
            if let woozVC = Controllers.cleaning.getController() as? CleaningViewController {
                woozVC.category = category
                navigationController?.pushViewController(woozVC, animated: true)
            }
        }
    }
}
