//
//  ToolBarView.swift
//  Kusto
//
//  Created by Kiet Truong on 18/03/2024.
//

import UIKit

protocol ToolBarViewDelegate: AnyObject {
    func didTapShare(_ vc: UIViewController, items: [IndexPath])
    func didTapDelete(_ vc: UIViewController, items: [IndexPath])
}

class ToolBarView: UIView {
    
    //MARK: - UI
    
    lazy private var btnShare: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var btnDelete: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "trash", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var lblTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "0 Photo Selected"
        return label
    }()
    
    //MARK: - PROPS
    
    weak var delegate: ToolBarViewDelegate?
    
    private var isTitleHidden: Bool = false
    private var items = [IndexPath]()
    
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
        let barWidth: CGFloat = UIScreen.main.bounds.width
        let barHeight: CGFloat = 50
        let barX: CGFloat = 0
        let barY: CGFloat = UIScreen.main.bounds.height + 100
        
        frame = CGRect(
            x: barX,
            y: barY,
            width: barWidth,
            height: barHeight
        )
        backgroundColor = UIColor.primary
        
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.pinEdgesToSuperView()
        
        stackView.addArrangedSubview(btnShare)
        stackView.addArrangedSubview(lblTitle)
        stackView.addArrangedSubview(btnDelete)
        
        NSLayoutConstraint.activate([
            btnShare.widthAnchor.constraint(equalToConstant: 50),
            btnDelete.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        lblTitle.isHidden = isTitleHidden
    }
    
    @objc private func didTapShareButton() {
        if let vc = parentViewController {
            delegate?.didTapShare(vc, items: items)
        }
    }
    
    @objc func didTapDeleteButton() {
        if let vc = parentViewController {
            delegate?.didTapDelete(vc, items: items)
        }
    }
    
    func setTitle(_ title: String) {
        lblTitle.text = title
    }
    
    func setItems(_ items: [IndexPath]) {
        self.items = items
    }
    
    func toggleShowTitle(_ hide: Bool) {
        // Use alpha instead of hidden to fix stackview constraint
        lblTitle.alpha = hide ? 0 : 1
    }
}
