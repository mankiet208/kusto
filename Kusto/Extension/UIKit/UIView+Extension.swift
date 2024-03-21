//
//  UIView+Extension.swift
//  Kusto
//
//  Created by Mac on 3/10/21.
//

import UIKit

//MARK: - CONSTRAINT
extension UIView {
    
    func pinEdgesToSuperView() {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
    
    func constraintSize(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}

//MARK: - ANIMATION
extension UIView {
    
    func addBlurEffect(with style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        addSubview(blurredEffectView)
    }
    
    func removeBlurEffect() {
        
    }
    
    func shake(completion: (() -> Void)? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let completion = completion {
                completion()
            }
        }
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}

extension UIView {
    
    var theme: Theme {
        get {
            return traitCollection.userInterfaceStyle == .dark  ? Theme.dark : Theme.light
        }
    }
    
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
