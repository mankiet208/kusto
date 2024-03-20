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
            }
        }
    }
    
    var album: Album!
    var photos = [Photo]()
    var selectedPhotos = [Photo]()
    
    var viewablePhotos = [ViewablePhoto]()
    
    var selectedIndex = [IndexPath]() {
        didSet {
            let barTitle = "\(selectedIndex.count) Photo Selected"
            vwToolBar.setTitle(barTitle)
        }
    }
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        
        view.addSubview(btnAdd)
        view.addSubview(vwToolBar)
        
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
    private func setupData() {
        guard let album = album else {
            return
        }
        SpinnerVC.showSpinner(on: self)
        DispatchQueue.background {
            if let index = UserDefaultsStore.listAlbum.firstIndex(where: {$0.id == album.id}) {
                self.photos = UserDefaultsStore.listAlbum[index].photos
                
                self.viewablePhotos = self.photos.map {
                    ViewablePhoto(type: .image, assetID: nil, url: nil, placeholder: $0.toUIImage()!)
                }
            }
        } completion: {
            SpinnerVC.hideSpinner()
            self.clvPhoto.reloadData()
            self.showAddButton()
        }
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
        showImagePicker()
    }
    
    @objc func didTapOptionButton() {
        guard let album = album else {
            return
        }
        for indexPath in selectedIndex {
            let photo = photos[indexPath.row]

            // Remove photo from array
            if let index = selectedIndex.firstIndex(of: indexPath) {
                selectedIndex.remove(at: index)
            }
            
            // Remove photo from document directory
            UIImage.clearPhotoCache(photoId: photo.name)
            
            // Update local data
            if let index = photos.firstIndex(where: {$0.name == photo.name}) {
                photos.remove(at: index)
            }
        }
        // Update UserDefaults
        if let index = UserDefaultsStore.listAlbum.firstIndex(where: {$0.id == album.id}) {
            UserDefaultsStore.listAlbum[index].photos = photos
        }
        
        // Update UI
        clvPhoto.reloadData()
    }
    
    @objc internal func didTapRemoveButton() {
        guard let album = album else {
            return
        }
        for indexPath in selectedIndex {
            let photo = photos[indexPath.row]

            // Remove photo from array
            if let index = selectedIndex.firstIndex(of: indexPath) {
                selectedIndex.remove(at: index)
            }
            
            // Remove photo from document directory
            UIImage.clearPhotoCache(photoId: photo.name)
            
            // Update local data
            if let index = photos.firstIndex(where: {$0.name == photo.name}) {
                photos.remove(at: index)
            }
        }
        // Update UserDefaults
        if let index = UserDefaultsStore.listAlbum.firstIndex(where: {$0.id == album.id}) {
            UserDefaultsStore.listAlbum[index].photos = photos
        }
        
        // Update UI
        clvPhoto.reloadData()
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
            // Select item
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
//            guard let photoDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotoDetailVC") as? PhotoDetailVC else {
//                return
//            }
//            photoDetailVC.selectedImageName = photos[indexPath.row].name
//            self.push(photoDetailVC)
            
            let toolBar = ToolBarView()
            toolBar.toggleShowTitle(true)
            
            let viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)
            viewerController.dataSource = self
            viewerController.footerView = toolBar

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

extension PhotoVC: ToolBarViewDelegate {
    
}

extension PhotoVC: ViewerControllerDataSource {
    func numberOfItemsInViewerController(_ viewerController: Viewer.ViewerController) -> Int {
        return viewablePhotos.count
    }
    
    func viewerController(_ viewerController: ViewerController, viewableAt indexPath: IndexPath) -> Viewable {
        return viewablePhotos[indexPath.row]
    }
}


