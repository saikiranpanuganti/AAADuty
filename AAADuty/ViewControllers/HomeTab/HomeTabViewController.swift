//
//  HomeTabViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 25/02/23.
//

import UIKit

protocol HomeTabViewControllerDelegate: AnyObject {
    func navigateToStart()
    func logoutTapped()
    func deleteAccountTapped()
    func goToStart()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSuccess), name: NSNotification.Name(loginSuccess), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func handleLoginSuccess() {
        sideMenuView.reloadSideMenu()
    }
    
    func navigateToBookingsVC() {
        if let controller = Controllers.bookingsTab.getController() as? BookingsViewController {
            controller.hideBackButton = false
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func navigateToProfileVC() {
        if let controller = Controllers.profileTab.getController() as? ProfileTabViewController {
            controller.hideBackButton = false
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func navigateToLoginVC() {
        navigationController?.pushViewController(Controllers.login.getController(), animated: true)
    }
    
    override func logoutUser() {
        showHideSideMenu()
        delegate?.logoutTapped()
    }
    
    func deleteAccountTapped() {
        guard let mobileNumer = AppData.shared.user?.mobileNumber else { return }
        
        showLoader()
        
        let bodyParams: [String: Any] = ["MobileNumber": mobileNumer]
        print("$$Delete Account: Url -\(Url.deleteAccount.getUrl())")
        print("$$Delete Account: bodyParams -\(bodyParams)")
        NetworkAdaptor.requestWithHeaders(urlString: Url.deleteAccount.getUrl(), method: .post, bodyParameters: bodyParams) { [weak self] data, response, error in
            self?.stopLoader()
            
            if let data = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let status = jsonData["Status"] as? String {
                            if status == "SUCCESS" {
                                self?.delegate?.goToStart()
                            }else {
                                self?.showAlert(title: "Error", message: "Something went wrong. Please try after sometime")
                            }
                        }
                    }else {
                        self?.showAlert(title: "Error", message: "Something went wrong. Please try after sometime")
                    }
                }catch {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }else {
                self?.showAlert(title: "Error", message: "Something went wrong. Please try after sometime")
            }
        }
    }
    
    override func handleSideMenuTap(menuType: MenuType) {
        if menuType == .orderHistory || menuType == .transactions {
            showHideSideMenu()
            navigateToBookingsVC()
        }else if menuType == .myProfile {
            showHideSideMenu()
            navigateToProfileVC()
        }else if menuType == .rateUs {
            showHideSideMenu()
            redirectToAppstore()
        }else if menuType == .contact {
            showHideSideMenu()
            contactUsTapped()
        }else if menuType == .deleteAccount {
            showHideSideMenu()
            if let _ = AppData.shared.user?.mobileNumber {
                delegate?.deleteAccountTapped()
            }
        }else if menuType == .login {
            showHideSideMenu()
            navigateToLoginVC()
        }
    }
    
    override func profileTapped() {
        showHideSideMenu()
        navigateToProfileVC()
    }
    
    func redirectToAppstore() {
        if let url  = URL(string: "itms-apps://apple.com/app/id6473516832"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func contactUsTapped() {
        let notificationsVC = Controllers.contactUs.getController()
        notificationsVC.modalPresentationStyle = .fullScreen
        notificationsVC.modalTransitionStyle = .crossDissolve
        self.present(notificationsVC, animated: true)
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
        let notificationsVC = Controllers.notificationsVC.getController()
        notificationsVC.modalPresentationStyle = .fullScreen
        notificationsVC.modalTransitionStyle = .crossDissolve
        self.present(notificationsVC, animated: true)
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
        }else if category.serviceType == .cleaning || category.serviceType == .sanitization || category.serviceType == .plumbing || category.serviceType == .acTech || category.serviceType == .electrician || category.serviceType == .pestControl {
            if let cleaningVC = Controllers.cleaning.getController() as? CleaningViewController {
                cleaningVC.category = category
                navigationController?.pushViewController(cleaningVC, animated: true)
            }
        }else if category.serviceType == .gasTech {
            if let gasTechVC = Controllers.gasTechnician.getController() as? GasTechnicianViewController {
                gasTechVC.category = category
                navigationController?.pushViewController(gasTechVC, animated: true)
            }
        }
    }
}
