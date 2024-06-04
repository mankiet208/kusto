//
//  PhotoInfoVC.swift
//  Kusto
//
//  Created by Kiet Truong on 25/03/2024.
//

import UIKit

class PhotoInfoVC: UIViewController {
    
    //MARK: - UI
    
    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = theme.text
        return label
    }()
    
    lazy var sizeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = theme.text
        label.textAlignment = .right
        return label
    }()
    
    lazy var formatLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = theme.text
        return label
    }()
    
    lazy var formatValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = theme.text
        label.textAlignment = .right
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    private var info: Info!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = isDarkMode ? .gray900 : .gray100
    }
    
    private func setupConstraints() {
        view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
                
        let stack1 = UIStackView(arrangedSubviews: [sizeLabel, UIView(), sizeValueLabel])
        stack1.axis = .horizontal
        stack1.distribution = .fillEqually
        
        let stack2 = UIStackView(arrangedSubviews: [formatLabel, UIView(), formatValueLabel])
        stack2.axis = .horizontal
        stack2.distribution = .fillEqually
        
        contentStackView.addArrangedSubview(stack1)
        contentStackView.addArrangedSubview(stack2)
        contentStackView.addArrangedSubview(UIView())
    }
    
    func setupData(photo: Photo) {
        self.info = Info(photo: photo)
        
        sizeLabel.text = "Size"
        sizeValueLabel.text = "\(info.size) KB"
        
        formatLabel.text = "Format"
        formatValueLabel.text = "\(info.format)"
    }
}


