//
//  TabVC.swift
//  Kusto
//
//  Created by Kiet Truong on 02/04/2024.
//

import UIKit

class TabVC: UITabBarController {
    
    let albumVC = AlbumVC()
    let settingVC = SettingVC()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()
        setupViewControllers()
    }
    
    private func setupTab() {
        delegate = self
        
        UITabBar.appearance().tintColor = theme.primary
        UITabBar.appearance().unselectedItemTintColor = theme.border
    }
    
    private func setupViewControllers() {
        let tabBarItem_1 = UITabBarItem(title: "Album",
                                        image: UIImage(systemName: "house"),
                                        selectedImage: UIImage(systemName: "house.fill"))
        let tabBarItem_2 = UITabBarItem(title: "Settings",
                                        image: UIImage(systemName: "gearshape"),
                                        selectedImage: UIImage(systemName: "gearshape.fill"))
        
        albumVC.tabBarItem = tabBarItem_1
        settingVC.tabBarItem = tabBarItem_2
        
        let navigationVC_1 = UINavigationController(rootViewController: albumVC)
        let navigationVC_2 = UINavigationController(rootViewController: settingVC)
        
        viewControllers = [navigationVC_1, navigationVC_2]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        albumVC.view.backgroundColor = theme.background
        settingVC.setThemeColor()
        view.layoutIfNeeded()
    }
}

extension TabVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
