//
//  UIViewController+Extension.swift
//  Kusto
//
//  Created by Mac on 3/5/21.
//

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func push(_ vc: UIViewController, animated: Bool = true, hideBottomBar: Bool = false) {
        vc.hidesBottomBarWhenPushed = hideBottomBar
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popTo(to vc: AnyClass, animated: Bool = true) {
        if let vc = navigationController?.viewControllers.filter({$0.isKind(of: vc)}).last {
            navigationController?.popToViewController(vc, animated: animated)
        }
    }
}
