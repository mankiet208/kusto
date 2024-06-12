//
//  AlertView.swift
//  Kusto
//
//  Created by kiettruong on 05/04/2021.
//

import UIKit

class AlertView: NSObject {
    
    class func showAlert(
        _ vc: UIViewController,
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = []
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if (actions.isEmpty) {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            for item in actions {
                alert.addAction(item)
            }
        }
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
