//
//  CarWashServiceTypeTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 11/03/23.
//

import UIKit

protocol CarWashServiceTypeTableViewCellDelegate: AnyObject {
    func serviceSelected(carWashService: CarWashService)
}

class CarWashServiceTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: CarWashServiceTypeTableViewCellDelegate?
    var carWashServices: [CarWashService]?

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
    
    func configureUI(carWashServices: [CarWashService]?) {
        self.carWashServices = carWashServices
        updateUI()
    }
}


extension CarWashServiceTypeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carWashServices?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceTypeCollectionViewCell", for: indexPath) as? ServiceTypeCollectionViewCell {
            cell.configureUI(carWashService: carWashServices?[indexPath.row], serviceColor: UIColor().getServiceColor(index: indexPath.row))
            return cell
        }
        return UICollectionViewCell()
    }
}
extension CarWashServiceTypeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let carWashService = carWashServices?[indexPath.row] {
            delegate?.serviceSelected(carWashService: carWashService)
        }
    }
}
extension CarWashServiceTypeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.height-5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
