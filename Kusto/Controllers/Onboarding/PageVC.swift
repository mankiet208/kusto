//
//  PageVC.swift
//  Kusto
//
//  Created by Kiet Truong on 11/06/2024.
//

import UIKit

class PageVC: BaseVC {
    
    //MARK: - UI

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.text = "This is a title"
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var lblDescription: UILabel = {
        let label = UILabel()
        label.text = "This is a description"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        view.backgroundColor = .gray300
    }

    //MARK: - PRIVATE
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(lblTitle)
        view.addSubview(lblDescription)
        
        let screenHeight = UIScreen.main.bounds.size.height
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight / 5),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            //
            lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 80),
            //
            lblDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 20),
        ])
    }
    
    //MARK: - PUBLIC
    
    func setup(model: OnboardingModel) {
        imageView.image = UIImage(named: model.imageName)
        lblTitle.text = model.title
        lblDescription.text = model.description
    }
}
