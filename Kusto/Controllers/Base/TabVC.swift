//
//  TabVC.swift
//  Kusto
//
//  Created by Kiet Truong on 02/04/2024.
//

import UIKit

class TabVC: UITabBarController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()
        setupViewControllers()
    }
    
    private func setupTab() {
        delegate = self
        tabBar.tintColor = theme.primary
    }
    
    private func setupViewControllers() {
        let albumVC = AlbumVC()
        let tabBarItem_1 = UITabBarItem(title: "Album",
                                        image: UIImage(systemName: "house"),
                                        selectedImage: UIImage(systemName: "house.fill"))
        albumVC.tabBarItem = tabBarItem_1
        let navigationVC_1 = UINavigationController(rootViewController: albumVC)
        
        let settingVC = SettingVC()
        let tabBarItem_2 = UITabBarItem(title: "Settings",
                                        image: UIImage(systemName: "gearshape"),
                                        selectedImage: UIImage(systemName: "gearshape.fill"))
        settingVC.tabBarItem = tabBarItem_2
        let navigationVC_2 = UINavigationController(rootViewController: settingVC)
        
        viewControllers = [navigationVC_1, navigationVC_2]
    }
}

extension TabVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
