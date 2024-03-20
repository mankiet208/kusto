//
//  PinCodeView.swift
//  Kusto
//
//  Created by Kiet Truong on 19/03/2024.
//

import UIKit

protocol PinCodeViewDelegate: AnyObject {
    func onSubmitPin(_ pinCode: String)
}

class PinCodeView: UIView {
    
    //MARK: - UI
    
    lazy private var txfPin_1: UnderlinedTextField = createPinField()
    lazy private var txfPin_2: UnderlinedTextField = createPinField()
    lazy private var txfPin_3: UnderlinedTextField = createPinField()
    lazy private var txfPin_4: UnderlinedTextField = createPinField()
    
    lazy private var pinCodeFields = [UnderlinedTextField]()
    
    lazy private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - PROPS
    
    weak var delegate: PinCodeViewDelegate?
    
    private var pinCount = 4
    
    private var pinCode: String = "" {
        didSet {
            refresh()
        }
    }
    
    //MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONFIG
    
    private func setupView() {
        addSubview(stackView)
        stackView.pinEdgesToSuperView()
        
        for _ in 1...pinCount {
            let pinField = createPinField()
            pinCodeFields.append(pinField)
            stackView.addArrangedSubview(pinField)
        }
    }
    
    private func createPinField() -> UnderlinedTextField {
        let field = UnderlinedTextField()
        field.font = UIFont.systemFont(ofSize: 30)
        field.textAlignment = .center
        field.isSecureTextEntry = true
        field.isUserInteractionEnabled = false
        field.underlineColor = theme.text.cgColor
        return field
    }
    
    
    func addPin(_ pin: String) {
        if (pinCode.count < 4) {
            let newPin = "\(pinCode)\(pin)"
            pinCode = newPin
        }
        if (pinCode.count == pinCount) {
            delegate?.onSubmitPin(pinCode)
        }
    }
    
    func removePin() {
        if (pinCode.count != 0) {
            let newCode = String(pinCode.dropLast())
            pinCode = newCode
        }
    }
    
    func clearPin() {
        pinCode = ""
    }
    
    private func refresh() {
        for i in 0..<pinCount {
            let newPin = pinCode[i]
            pinCodeFields[i].text = newPin
            pinCodeFields[i].underlineColor = newPin.isEmpty ? theme.text.cgColor : nil
        }
    }
}
