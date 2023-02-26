//
//  PromotionCollectionViewCell.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 26/02/23.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
        pageControl.numberOfPages = 3
    }

    @IBAction func pageControllerAction(_ sender: UIPageControl) {
        bannerCollectionView.isPagingEnabled = false
        self.bannerCollectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .left, animated: false)
        bannerCollectionView.isPagingEnabled = true
    }
}

extension PromotionCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            cell.configureUI(imageName: "banner")
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

extension PromotionCollectionViewCell: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let visibleRect = CGRect(origin: self.bannerCollectionView.contentOffset, size: self.bannerCollectionView.bounds.size)
       let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
       if let visibleIndexPath = self.bannerCollectionView.indexPathForItem(at: visiblePoint) {
                self.pageControl.currentPage = visibleIndexPath.row
       }
    }
}

extension PromotionCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bannerCollectionView.frame.width, height: bannerCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
