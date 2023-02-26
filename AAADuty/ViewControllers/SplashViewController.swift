//
//  SplashViewController.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 24/02/23.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        let top = view.safeAreaInsets.top
        topSafeAreaHeight = top
        
        let bottom = view.safeAreaInsets.bottom
        bottomSafeAreaHeight = bottom
    }

    func getCategories() {
        NetworkAdaptor.requestWithHeaders(urlString: Url.categories.getUrl(), method: .get) { data, response, error in
            if let data = data {
                do {
                    let cateogriesModel = try JSONDecoder().decode(CategoriesModel.self, from: data)
                    AppData.shared.categories = cateogriesModel.categories ?? []
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.pushViewController(Controllers.tabBar.getController(), animated: true)
                    }
                }catch {
                    print("Error: SplashViewController getCategories - \(error.localizedDescription)")
                }
            }
        }
    }
}
