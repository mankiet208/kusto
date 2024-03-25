//
//  ToolBarView.swift
//  Kusto
//
//  Created by Kiet Truong on 18/03/2024.
//

import UIKit

protocol ToolBarViewDelegate: AnyObject {
    func didTapShare(_ toolBarView: ToolBarView, controller: UIViewController, for indexPaths: [IndexPath])
    func didTapDelete(_ toolBarView: ToolBarView, controller: UIViewController, for indexPaths: [IndexPath])
    func didTapInfo(_ toolBarView: ToolBarView, controller: UIViewController, for indexPath: IndexPath)
}

class ToolBarView: UIView {
    
    //MARK: - UI
        
    lazy private var btnShare: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var btnDelete: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "trash", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var btnInfo: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "info.circle", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(infoAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var lblTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    //MARK: - PROPS
    
    weak var delegate: ToolBarViewDelegate?
    
    private var indexPaths = [IndexPath]()
    
    var isViewerFooter: Bool = true {
        didSet {
            lblTitle.isHidden = isViewerFooter
            btnInfo.isHidden = !isViewerFooter
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
        stackView.addArrangedSubview(btnInfo)
        stackView.addArrangedSubview(btnDelete)

        NSLayoutConstraint.activate([
            btnShare.widthAnchor.constraint(equalToConstant: 50),
            btnDelete.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func shareAction() {
        if let controller = parentViewController {
            delegate?.didTapShare(self, controller: controller, for: indexPaths)
        }
    }
    
    @objc func deleteAction() {
        if let controller = parentViewController {
            delegate?.didTapDelete(self, controller: controller, for: indexPaths)
        }
    }
    
    @objc func infoAction() {
        if let controller = parentViewController,
           let indexPath = indexPaths.first {
            delegate?.didTapInfo(self, controller: controller, for: indexPath)
        }
    }
    
    func setTitle(_ title: String) {
        lblTitle.text = title
    }
    
    func setItems(_ indexPaths: [IndexPath]) {
        self.indexPaths = indexPaths
    }
    
    func toggleShowTitle(_ hide: Bool) {
        // Use alpha instead of hidden to fix stackview constraint
        lblTitle.alpha = hide ? 0 : 1
    }
}
