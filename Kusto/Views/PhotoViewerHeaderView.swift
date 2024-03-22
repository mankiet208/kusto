//
//  ViewerHeaderView.swift
//  Kusto
//
//  Created by Kiet Truong on 22/03/2024.
//

import UIKit

protocol PhotoViewerHeaderViewDelegate: AnyObject {
    func didTapClose(_ controller: UIViewController)
    func didTapEdit(_ controller: UIViewController, for indexPath: IndexPath)
}

class PhotoViewerHeaderView: UIView {
    
    static let ButtonSize = CGFloat(50.0)
    static let TopMargin = CGFloat(14.0)
    
    
    lazy var closeButton: UIButton = {
        let image = UIImage.close
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        
        let button = UIButton(type: .custom)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = theme.onBackground
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(theme.onBackground, for: .normal)
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: PhotoViewerHeaderViewDelegate?
    
    var index: IndexPath?
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(closeButton)
        addSubview(editButton)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        closeButton.frame = CGRect(x: 4,
                                   y: PhotoViewerHeaderView.TopMargin,
                                   width: PhotoViewerHeaderView.ButtonSize,
                                   height: PhotoViewerHeaderView.ButtonSize)
        
        editButton.frame = CGRect(x: UIScreen.main.bounds.width - PhotoViewerHeaderView.ButtonSize - 4,
                                  y: PhotoViewerHeaderView.TopMargin,
                                  width: PhotoViewerHeaderView.ButtonSize,
                                  height: PhotoViewerHeaderView.ButtonSize)
    }
    
    func setSelectedItem(_ index: IndexPath?) {
        self.index = index
    }

    @objc func closeAction() {
        if let controller = parentViewController {
            self.delegate?.didTapClose(controller)
        }
    }
    
    @objc func editAction() {
        if let controller = parentViewController,
           let index = index {
            self.delegate?.didTapEdit(controller, for: index)
        }
    }
}
