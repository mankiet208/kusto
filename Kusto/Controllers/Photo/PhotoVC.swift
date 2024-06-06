//
//  ViewController.swift
//  Kusto
//
//  Created by Kiet Truong on 3/5/21.
//

import UIKit
import BSImagePicker
import Photos
import Viewer
import BrightroomUI
import BrightroomEngine

protocol PhotoVCDelegate: AnyObject {
    func didUpdatePhotos(in album: Album)
}

class PhotoVC: BaseVC {
    
    //MARK: - CONSTANTS
    
    private let viewBottomConstraint: CGFloat = 80
    
    //MARK: - UI
    
    lazy var clvPhoto: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout.init())
        collection.register(PhotoCell.nib(), forCellWithReuseIdentifier: PhotoCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceVertical = true
        collection.allowsMultipleSelection = false
        collection.isEditing = false
        collection.backgroundColor = .clear
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewBottomConstraint, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy private var vwToolBar: ToolBarView = {
        let toolBar = ToolBarView()
        toolBar.delegate = self
        toolBar.isViewerFooter = false
        toolBar.setTitle("0 Photo Selected")
        return toolBar
    }()
    
    private lazy var photoViewerHeaderView: PhotoViewerHeaderView = {
        let headerView = PhotoViewerHeaderView()
        headerView.delegate = self
        headerView.alpha = 0
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    lazy private var btnAdd: UIButton = {
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 44
        let buttonX: CGFloat = UIScreen.main.bounds.size.width / 2 - buttonWidth / 2
        let buttonY: CGFloat = UIScreen.main.bounds.size.height + 100
        
        let button = UIButton(type: .system)
        button.frame = CGRect(
            x: buttonX,
            y: buttonY,
            width: buttonWidth,
            height: buttonHeight
        )
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .primary
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy private var btnEdit: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        button.tintColor = UIColor.primary
        return button
    }()
    
    lazy private var btnDone: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        button.tintColor = UIColor.primary
        return button
    }()
    
    //MARK: - PROPS
    
    weak var delegate: PhotoVCDelegate?
    
    var album: Album!
    
    var photos = [Photo]() {
        didSet {
            btnEdit.isHidden = photos.isEmpty
        }
    }
    
    var selectedIndex = [IndexPath]() {
        didSet {
            let barTitle = "\(selectedIndex.count) Photo Selected"
            vwToolBar.setTitle(barTitle)
            vwToolBar.setItems(selectedIndex)
        }
    }
    
    var isEditingMode: Bool = false {
        didSet {
            if isEditingMode {
                hideAddButton()
                showToolBar()
                navigationItem.rightBarButtonItem = btnDone
            } else {
                showAddButton()
                hideToolBar()
                navigationItem.rightBarButtonItem  = btnEdit
                
                for indexPath in selectedIndex {
                    if let cell = clvPhoto.cellForItem(at: indexPath) as? PhotoCell {
                        cell.toggleSelected(false)
                    }
                }
                selectedIndex.removeAll()
                vwToolBar.setItems([])
            }
        }
    }
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupData()
        setupGesture()
    }
    
    //MARK: - CONFIG
    
    override func setupRightBarButton() {
        navigationItem.rightBarButtonItem = btnEdit
    }
    
    @objc func didTapRightBarButton() {
        isEditingMode = !isEditingMode
    }
}

//MARK: - PRIVATE METHOD
extension PhotoVC {
    
    private func setupView() {
        title = album.name
        
        view.addSubview(clvPhoto)
        view.addSubview(btnAdd)
        view.addSubview(vwToolBar)
        
        clvPhoto.pinEdgesToSuperView()
    }
    
    private func setupData() {
        guard let album = album else {
            return
        }
        SpinnerVC.show(on: self)
        DispatchQueue.background {
            if let index = album.index {
                self.photos = UserDefaultsStore.listAlbum[index].photos
            }
        } completion: {
            SpinnerVC.hide()
            self.clvPhoto.reloadData()
            self.showAddButton()
        }
    }
    
    private func setupGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(didLongPressPhoto))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        clvPhoto.addGestureRecognizer(longPressGesture)
    }
    
    private func showAddButton() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 2,
            options: .curveEaseInOut
        ) {
            self.btnAdd.isHidden = false
            self.btnAdd.frame.origin.y = UIScreen.main.bounds.size.height - self.viewBottomConstraint
        }
    }
    
    private func hideAddButton() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 2,
            options: .curveEaseInOut
        ) {
            self.btnAdd.frame.origin.y = UIScreen.main.bounds.size.height + self.viewBottomConstraint
        } completion: { finish in
            self.btnAdd.isHidden = true
        }
    }
    
    private func showToolBar() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 2,
            options: .curveEaseInOut
        ) {
            self.vwToolBar.isHidden = false
            self.vwToolBar.frame.origin.y = UIScreen.main.bounds.size.height - self.viewBottomConstraint
        }
    }
    
    private func hideToolBar() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 2,
            options: .curveEaseInOut
        ) {
            self.vwToolBar.frame.origin.y = UIScreen.main.bounds.size.height + self.viewBottomConstraint
        } completion: { finish in
            self.vwToolBar.isHidden = true
        }
    }
    
    private func setEditingMode(_ flag: Bool) {
        isEditingMode = flag
    }
}

//MARK: - ACTIONS
extension PhotoVC {
    
    @objc private func didTapAddButton() {
        PermissionHelper.shared.checkPhotos { [weak self] granted in
            guard let self = self else { return }
            if granted {
                self.showImagePicker()
            } else {
                AlertView.showAlert(
                    self,
                    title: "Need Photos permission",
                    message: "Please turn on Photos permission in app settings",
                    actions: [
                        UIAlertAction(title: "Cancel", style: .default, handler: nil),
                        UIAlertAction(title: "Settings", style: .default, handler: { _ in
                            PermissionHelper.shared.openSettings()
                        })
                    ]
                )
            }
        }
    }
    
    @objc private func didLongPressPhoto(_ gesture : UILongPressGestureRecognizer!) {
        if isEditingMode {
            return
        }
        
        if gesture.state != .began {
            return
        }
        
        let location = gesture.location(in: clvPhoto)
        
        if let indexPath = clvPhoto.indexPathForItem(at: location) {
            guard let cell = clvPhoto.cellForItem(at: indexPath) as? PhotoCell else {
                return
            }
            
            // do stuff with the cell
            selectedIndex.append(indexPath)
            
            cell.toggleSelected(true)
            
            setEditingMode(true)

        } else {
            print("Couldn't find indexpath")
        }
    }
}

extension PhotoVC: UIGestureRecognizerDelegate {}
