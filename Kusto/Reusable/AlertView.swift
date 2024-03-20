//
//  AlertView.swift
//  Kusto
//
//  Created by kiettruong on 05/04/2021.
//

import UIKit

class AlertView: NSObject {
    class func showAlert(_ vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
