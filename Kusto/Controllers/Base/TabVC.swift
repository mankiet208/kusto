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
        tabBar.tintColor = theme.primary
    }
    
    private func setupViewControllers() {
        let tabBarItem_1 = UITabBarItem(title: LocalizationKey.album.localized(),
                                        image: UIImage(systemName: "house"),
                                        selectedImage: UIImage(systemName: "house.fill"))
        let tabBarItem_2 = UITabBarItem(title: LocalizationKey.settings.localized(),
                                        image: UIImage(systemName: "gearshape"),
                                        selectedImage: UIImage(systemName: "gearshape.fill"))
        
        albumVC.tabBarItem = tabBarItem_1
        settingVC.tabBarItem = tabBarItem_2
        
        let navigationVC_1 = UINavigationController(rootViewController: albumVC)
        let navigationVC_2 = UINavigationController(rootViewController: settingVC)
        
        viewControllers = [navigationVC_1, navigationVC_2]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        albumVC.applyTheme()
        settingVC.applyTheme()
    }
}

extension TabVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
