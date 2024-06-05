//
//  KeyboardCell.swift
//  Kusto
//
//  Created by Kiet Truong on 19/03/2024.
//

import UIKit

class KeyboardCell: UICollectionViewCell {
        
    lazy var btnKeyboard: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 20)
        button.setTitleColor(theme.text, for: .normal)
        button.imageView?.tintColor = .primary
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(btnKeyboard)
        NSLayoutConstraint.activate([
            btnKeyboard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            btnKeyboard.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = theme.surface
    }
}

extension KeyboardCell {
    static let identifier: String = "KeyboardCell"
}
