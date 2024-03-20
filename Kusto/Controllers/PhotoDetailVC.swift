//
//  PhotoDetailVC.swift
//  Kusto
//
//  Created by kiettruong on 19/04/2021.
//

import UIKit

class PhotoDetailVC: BaseVC {
    
    //MARK: - CONSTANTS
    
    private let MIN_ZOOM_SCALE: CGFloat = 1.0
    private let MAX_ZOOM_SCALE: CGFloat = 5.0
    private let BOTTOM_CONSTRAINT: CGFloat = 80
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imvPhoto: UIImageView!
    
    //MARK: - UI
    
    private var vwToolBar: UIView = {
        let barWidth: CGFloat = UIScreen.main.bounds.width
        let barHeight: CGFloat = 85
        let barX: CGFloat = 0
        let barY: CGFloat = UIScreen.main.bounds.height - 80
        
        let toolBar = UIView()
        toolBar.frame = CGRect(
            x: barX,
            y: barY,
            width: barWidth,
            height: barHeight
        )
        return toolBar
    }()
    
    private lazy var btnOption: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .primary
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var btnRemove: UIButton = {
        let button = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "trash", withConfiguration: imageConfig), for: .normal)
        button.imageView?.tintColor = .primary
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - PROPS
    
    var selectedImageName: String?
    
    var isZoomed: Bool = false
    
    var isShowToolBar: Bool = true
    
    //MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(vwToolBar)
        
        configEditToolBar()
        configImageView()
        configScrollView()
        configGesture()
        
        if let imageName = selectedImageName {
            let imagePath = UIImage.getDocumentsDirectory().appendingPathComponent(imageName).path
            imvPhoto.image = UIImage(contentsOfFile: imagePath)
        }
    }
}

//MARK: - CONFIG
extension PhotoDetailVC {
    
    private func configImageView() {
        imvPhoto.sizeToFit()
    }
    
    private func configScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = MIN_ZOOM_SCALE
        scrollView.maximumZoomScale = MAX_ZOOM_SCALE
    }
    
    private func configGesture() {
        let singleTapScreen = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        singleTapScreen.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTapScreen)
        
        let doubleTapPhoto = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapPhoto))
        doubleTapPhoto.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapPhoto)
        
        // Force the single tap to wait and ensure that the tap event is not a double tap.
        singleTapScreen.require(toFail: doubleTapPhoto)
    }
    
    private func configEditToolBar() {
        
        vwToolBar.addBlurEffect(with: .regular)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        vwToolBar.addSubview(stackView)
        stackView.pinEdgesToSuperView()
        
        stackView.addArrangedSubview(btnOption)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(btnRemove)
        
        btnOption.translatesAutoresizingMaskIntoConstraints = false
        btnRemove.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnOption.widthAnchor.constraint(equalTo: vwToolBar.widthAnchor, multiplier: 0.2),
            btnRemove.widthAnchor.constraint(equalTo: vwToolBar.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func toggleShowToolBar(_ isOn: Bool) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0
        ) {
            self.vwToolBar.alpha = isOn ? 1 : 0
        }
    }
}

//MARK: - ACTIONS
extension PhotoDetailVC {
    
    @objc func didTapPhoto() {
        isShowToolBar = !isShowToolBar
        toggleShowToolBar(isShowToolBar)
    }
    
    @objc func didDoubleTapPhoto() {
        if isZoomed {
            scrollView.setZoomScale(MIN_ZOOM_SCALE, animated: true)
        } else {
            scrollView.setZoomScale(MAX_ZOOM_SCALE, animated: true)
        }
        isZoomed = !isZoomed
    }
    
    @objc private func didTapOptionButton() {
        print("TAP OPTION")
    }
    
    @objc private func didTapRemoveButton() {
       print("TAP REMOVE")
    }
}

//MARK: - UIScrollViewDelegate
extension PhotoDetailVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imvPhoto
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imvPhoto.image {
                let ratioW = imvPhoto.frame.width / image.size.width
                let ratioH = imvPhoto.frame.height / image.size.height

                let ratio = ratioW < ratioH ? ratioW : ratioH

                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio

                let left = 0.5 * (newWidth * scrollView.zoomScale > imvPhoto.frame.width
                                    ? (newWidth - imvPhoto.frame.width)
                                    : (scrollView.frame.width - scrollView.contentSize.width))
                
                let top = 0.5 * (newHeight * scrollView.zoomScale > imvPhoto.frame.height
                                    ? (newHeight - imvPhoto.frame.height)
                                    : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}
