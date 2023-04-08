//
//  SlotsTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 07/04/23.
//

import UIKit

protocol SlotsTableViewCellDelegate: AnyObject {
    func slotSelected(slot: Slot)
}

class SlotsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: SlotsTableViewCellDelegate?
    var slots: [Slot]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "SlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlotCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func configureUI(slots: [Slot]?) {
        self.slots = slots
        updateUI()
    }
}


extension SlotsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slots?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCollectionViewCell", for: indexPath) as? SlotCollectionViewCell {
            cell.configureUI(slot: slots?[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
extension SlotsTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let slot = slots?[indexPath.row] {
            delegate?.slotSelected(slot: slot)
        }
    }
}
extension SlotsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 36)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
}
