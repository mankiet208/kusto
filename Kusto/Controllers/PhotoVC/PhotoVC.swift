//
//  ViewController.swift
//  Kusto
//
//  Created by Mac on 3/5/21.
//

import UIKit
import BSImagePicker
import Photos
import Viewer

class PhotoVC: BaseVC {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var clvPhoto: UICollectionView!
    
    //MARK: - CONSTANTS
    
    private let viewBottomConstraint: CGFloat = 80
    
    //MARK: - UI
    
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
    
    lazy private var vwToolBar = ToolBarView()
    
    //MARK: - PROPS
    
    var isEditingMode: Bool = false {
        didSet {
            if isEditingMode {
                hideAddButton()
                showToolBar()
                navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .done,
                    target: self,
                    action: #selector(didTapRightBarButton)
                )
            } else {
                showAddButton()
                hideToolBar()
                navigationItem.rightBarButtonItem  = UIBarButtonItem(
                    barButtonSystemItem: .edit,
                    target: self,
                    action: #selector(didTapRightBarButton)
                )
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
    
    var album: Album!
    var photos = [Photo]()
    var selectedPhotos = [Photo]()
    
    var selectedIndex = [IndexPath]() {
        didSet {
            let barTitle = "\(selectedIndex.count) Photo Selected"
            vwToolBar.setTitle(barTitle)
            vwToolBar.setItems(selectedIndex)
        }
    }
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
        setupData()
    }
    
    //MARK: - CONFIG
    
    override func setupRightBarButton() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        addButton.tintColor = UIColor.primary
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func didTapRightBarButton() {
        isEditingMode = !isEditingMode
    }
}

//MARK: - PRIVATE METHOD
extension PhotoVC {
    
    private func setupView() {
        title = album.name
        view.addSubview(btnAdd)
        view.addSubview(vwToolBar)
        vwToolBar.delegate = self
    }
    
    private func setupCollectionView() {
        clvPhoto.register(PhotoCell.nib(), forCellWithReuseIdentifier: PhotoCell.identifier)
        clvPhoto.collectionViewLayout = UICollectionViewFlowLayout()
        clvPhoto.dataSource = self
        clvPhoto.delegate = self
        clvPhoto.alwaysBounceVertical = true
        clvPhoto.allowsMultipleSelection = false
        clvPhoto.isEditing = false
        clvPhoto.backgroundColor = .clear
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
    
    private func setupData() {
        guard let album = album else {
            return
        }
        SpinnerVC.show(on: self)
        DispatchQueue.background {
            if let index = UserDefaultsStore.listAlbum.firstIndex(where: {$0.id == album.id}) {
                self.photos = UserDefaultsStore.listAlbum[index].photos
            }
        } completion: {
            SpinnerVC.hide()
            self.clvPhoto.reloadData()
            self.showAddButton()
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
    
    private func deletePhotos(_ items: [IndexPath]) {
        guard let album = album else {
            return
        }
        SpinnerVC.show(on: self)
        DispatchQueue.background {
            for indexPath in items {
                let photo = self.photos[indexPath.row]
                
                // Remove photo from document directory
                UIImage.clearPhotoCache(photoId: photo.name)
                
                // Update local data
                if let index = self.photos.firstIndex(where: {$0.name == photo.name}) {
                    self.photos.remove(at: index)
                }
            }
            // Update UserDefaults
            if let index = UserDefaultsStore.listAlbum.firstIndex(where: {$0.id == album.id}) {
                UserDefaultsStore.listAlbum[index].photos = self.photos
            }
        } completion: {
            SpinnerVC.hide()
            self.isEditingMode = false
            self.selectedIndex.removeAll()
            self.clvPhoto.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension PhotoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath)
                as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photo = photos[indexPath.row]
        let photoVM = PhotoCellViewModel(from: photo)
        cell.configure(with: photoVM, for: indexPath)
        
        let isCellSelected = selectedIndex.contains(indexPath)
        cell.toggleSelected(isCellSelected)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension PhotoVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if isEditingMode {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {
                return
            }
            if selectedIndex.contains(indexPath) {
                // Unselect
                if let index = selectedIndex.firstIndex(where: { $0 == indexPath }) {
                    selectedIndex.remove(at: index)
                }
                cell.toggleSelected(false)
            } else {
                // Select
                selectedIndex.append(indexPath)
                cell.toggleSelected(true)
            }
        } else {
            // Show photo viewer
            let toolBar = ToolBarView()
            toolBar.delegate = self
            toolBar.setItems([indexPath])
            toolBar.toggleShowTitle(false)
            toolBar.setTitle(photos[indexPath.row].imageSize)

            let viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)
            viewerController.dataSource = self
            viewerController.footerView = toolBar
            viewerController.modalTransitionStyle = .crossDissolve

            present(viewerController, animated: false, completion: nil)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth / 3 - 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

//MARK: - ToolBarViewDelegate
extension PhotoVC: ToolBarViewDelegate {
    
    func didTapShare(_ controller: UIViewController, items: [IndexPath]) {
        let shareItems = items.map { photos[$0.row].image }
        let vc = UIActivityViewController(
            activityItems: shareItems as [Any],
            applicationActivities: nil
        )
        controller.present(vc, animated: true)
    }
    
    func didTapDelete(_ controller: UIViewController, items: [IndexPath]) {
        let alertTitle = selectedIndex.count > 1 ? "photos" : "photo"
        AlertView.showAlert(
            controller,
            title: "Delete \(alertTitle)",
            message: "Are you sure you want to delete?",
            actions: [
                UIAlertAction(title: "Cancel", style: .cancel),
                UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    self?.deletePhotos(items)
                    controller.dismiss(animated: true)
                })
            ]
        )
    }
}

//MARK: - ViewerControllerDataSource
extension PhotoVC: ViewerControllerDataSource {

    func numberOfItemsInViewerController(_ viewerController: Viewer.ViewerController) -> Int {
        return photos.count
    }

    func viewerController(_ viewerController: ViewerController, viewableAt indexPath: IndexPath) -> Viewable {
        return photos[indexPath.row].viewable
    }
}
