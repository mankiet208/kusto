//
//  ChangePinVC.swift
//  Kusto
//
//  Created by Kiet Truong on 05/06/2024.
//

import UIKit

class ChangePinVC: BaseVC {
    
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
    }
    
    //MARK: - PRIVATE
    
    private func setupView() {
        lblTitle.text = "Change your PIN"
        
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
    }
    
    private func confirmPIN(_ pin: String) {
        KeychainWrapper.standard.set(pin, forKey: KeychainWrapper.pinCode)
        
        AlertView.showAlert(self, title: "PIN has changed", message: nil, actions: [
            UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.pop()
            })
        ])
    }
}

extension ChangePinVC: KeyboardViewDelegate {
    
    func didTapNumberKey(_ key: Int) {
        pinView.addPin("\(key)")
    }
    
    func didTapDelete() {
        pinView.removePin()
    }
    
    func didTapBiometric() {}
}

extension ChangePinVC: PinCodeViewDelegate {
    
    func onSubmitPin(_ pin: String) {
        
        if myPIN == pin {
            AlertView.showAlert(self, title: "Please choose a new PIN", message: nil, actions: [
                UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    self?.pinView.clearPin()
                })
            ])
        } else {
            AlertView.showAlert(self, title: "Are you sure?", message: nil, actions: [
                UIAlertAction(title: "Reset", style: .default, handler: { _ in
                    self.pinView.clearPin()
                }),
                UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                    self?.confirmPIN(pin)
                })
            ])
        }
    }
}
