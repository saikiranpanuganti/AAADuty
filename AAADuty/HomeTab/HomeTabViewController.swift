//
//  HomeTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

class HomeTabViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sideMenuView = SideMenuView.instanceFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()

        addSideMenuView()
        
        collectionView.register(UINib(nibName: "PromotionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PromotionCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func addSideMenuView() {
        view.addSubview(sideMenuView)
        sideMenuView.isHidden = true
        
        sideMenuView.translatesAutoresizingMaskIntoConstraints = false
        sideMenuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        sideMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: sideMenuWidth).isActive = true
    }

}

extension HomeTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionViewCell", for: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeTabViewController: UICollectionViewDelegate {
    
}

extension HomeTabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width-10, height: promotionCellHeight)
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
