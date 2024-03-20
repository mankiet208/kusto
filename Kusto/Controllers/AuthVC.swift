//
//  AuthVC.swift
//  Kusto
//
//  Created by Kiet Truong on 19/03/2024.
//

import UIKit
import LocalAuthentication

class AuthVC: BaseVC {
    
    //MARK: - UI
    
    lazy private var lblTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = theme.text
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var pinView: PinCodeView = {
        let pinCode = PinCodeView()
        pinCode.translatesAutoresizingMaskIntoConstraints = false
        return pinCode
    }()
    
    lazy private var vwKeyboard: KeyboardView = {
        let view = KeyboardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - PROPS
    
    private var myPIN: String? {
        get {
            return KeychainWrapper.standard.string(forKey: KeychainWrapper.pinCode)
        }
    }
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        vwKeyboard.delegate = self
        pinView.delegate = self
        
        showBiometric()
    }
    
    //MARK: - CONFIG
    
    private func setupView() {        
        view.addSubview(lblTitle)
        NSLayoutConstraint.activate([
            lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblTitle.topAnchor.constraint(equalTo: view.topAnchor,
                                          constant:  UIScreen.main.bounds.height / 4)
        ])
        
        view.addSubview(pinView)
        NSLayoutConstraint.activate([
            pinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pinView.widthAnchor.constraint(equalToConstant: 200),
            pinView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(vwKeyboard)
        NSLayoutConstraint.activate([
            vwKeyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwKeyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vwKeyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vwKeyboard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
        
        if myPIN != nil {
            lblTitle.text = "Enter your PIN"
        } else {
            lblTitle.text = "Setup your PIN"
        }
    }
    
    //MARK: - FUNCTION
    
    private func showBiometric() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.dismiss(animated: true)
                    } else {
                        // error
                        print("> Biometric error")
                    }
                }
            }
        } else {
            // no biometry
            if let error = error {
                print(error)
            }
        }
    }
    
    private func confirmPIN(_ pin: String) {
        if myPIN == nil {
            KeychainWrapper.standard.set(pin, forKey: KeychainWrapper.pinCode)
            dismiss(animated: true)
        } else {
            if myPIN == pin {
                dismiss(animated: true)
            } else {
                // Wrong PIN
                pinView.shake() { [weak self] in
                    self?.pinView.clearPin()
                }
            }
        }
    }
}

extension AuthVC: KeyboardViewDelegate {
    
    func didTapNumberKey(_ key: Int) {
        pinView.addPin("\(key)")
    }
    
    func didTapDelete() {
        pinView.removePin()
    }
    
    func didTapBiometric() {
        if myPIN == nil {
            let alert = UIAlertController(title: "Please setup your PIN", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        } else {
            showBiometric()
        }
    }
}

extension AuthVC: PinCodeViewDelegate {
    
    func onSubmitPin(_ pin: String) {
        if myPIN == nil {
            let alert = UIAlertController(title: "Confirm PIN code", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
                self.pinView.clearPin()
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.confirmPIN(pin)
            }))
            present(alert, animated: true)
        } else {
            confirmPIN(pin)
        }
    }
}
