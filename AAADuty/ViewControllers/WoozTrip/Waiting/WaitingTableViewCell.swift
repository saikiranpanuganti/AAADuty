//
//  WaitingTableViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 17/03/23.
//

import UIKit

protocol WaitingTableViewCellDelegate: AnyObject {
    func waitingSelected(selected: Bool)
    func waitingTimeSelected(waitingTime: WaitingTime?)
}

class WaitingTableViewCell: UITableViewCell {
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    weak var delegate: WaitingTableViewCellDelegate?
    var waitingTimes: [WaitingTime]?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(UINib(nibName: "WaitingTimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WaitingTimeCollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        selectButton.tag = 0
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.collectionView.reloadData()
        }
    }
    
    func configureUI(waitingTimes: [WaitingTime]?) {
        self.waitingTimes = waitingTimes
        updateUI()
    }
    
    @IBAction func selectTapped() {
        if selectButton.tag == 0 {
            selectButton.isSelected = true
            selectButton.tag = 1
            delegate?.waitingSelected(selected: true)
        }else {
            selectButton.isSelected = false
            selectButton.tag = 0
            delegate?.waitingSelected(selected: false)
        }
    }
}

extension WaitingTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return waitingTimes?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaitingTimeCollectionViewCell", for: indexPath) as? WaitingTimeCollectionViewCell {
            cell.configureUI(waitingTime: waitingTimes?[indexPath.item])
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}
extension WaitingTableViewCell: UICollectionViewDelegate {
    
}
extension WaitingTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}


extension WaitingTableViewCell: WaitingTimeCollectionViewCellDelegate {
    func waitingTimeTapped(waitingTime: WaitingTime?) {
        if let waitingTime = waitingTime {
            for (index, time) in (waitingTimes ?? []).enumerated() {
                if time.id == waitingTime.id {
                    waitingTimes?[index].isSelected = true
                }else {
                    waitingTimes?[index].isSelected = false
                }
            }
            updateUI()
            delegate?.waitingTimeSelected(waitingTime: waitingTime)
        }
    }
}
