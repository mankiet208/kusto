//
//  BaseVC.swift
//  Kusto
//
//  Created by Kiet Truong on 3/5/21.
//

import UIKit

enum UINavigationBarRightButtonType : Int {
    case none
    case search
    case tick
    case done
    case add
    case addfriends
    case share
}

enum UINavigationBarLeftButtonType : Int {
    case none
    case back
    case menu
    case cross
}

protocol BaseVCDelegate {
    func rightNavigationBarButtonClicked()
    func leftNavigationBarButtonClicked()
}

class BaseVC: UIViewController {
    
    var baseDelegate: BaseVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupNavigationBar()
        setupLeftBarButton()
        setupRightBarButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIApplication.didBecomeActiveNotification, object: nil)
        
        baseDelegate = nil
    }
    
    @objc func rightNavigationButtonClicked(_ sender: AnyObject) {
        self.baseDelegate?.rightNavigationBarButtonClicked()
    }
    
    @objc func leftNavigationButtonClicked(_ sender: AnyObject) {
        self.baseDelegate?.leftNavigationBarButtonClicked()
    }
    
    @objc func openAndCloseActivity(_ notification: Notification)  {
        if notification.name == UIApplication.didBecomeActiveNotification{
            onResume()
        } else{
            onPause()
        }
    }
    
    func onPause() {}
    
    func onResume() {}
    
    //MARK: - CONFIG
    
    func setupViewController() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.openAndCloseActivity),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.openAndCloseActivity),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        view.backgroundColor = theme.background
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .primary
        navigationController?.navigationBar.barTintColor = isDarkMode ? Theme.dark.background : .white
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.primary,
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.primary
        ]
    }
    
    func setupLeftBarButton() {}
    
    func setupRightBarButton() {}
    
    //MARK: - METHODS
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
}
