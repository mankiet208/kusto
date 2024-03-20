//
//  SpinnerView.swift
//  Kusto
//
//  Created by kiettruong on 12/04/2021.
//

import UIKit

class SpinnerVC: UIViewController {
    
    static let shared = SpinnerVC()
    
    let spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        
        spinner.color = .primary

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    static func showSpinner(on vc: UIViewController) {
        let child = SpinnerVC.shared
        vc.addChild(child)
        child.view.frame = vc.view.frame
        vc.view.addSubview(child.view)
        child.didMove(toParent: vc)
    }
    
    static func hideSpinner() {
        let child = SpinnerVC.shared
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
