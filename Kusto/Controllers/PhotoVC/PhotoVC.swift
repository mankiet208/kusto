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
import BrightroomUI
import BrightroomEngine

protocol PhotoVCDelegate: AnyObject {
    func didUpdatePhotos(in album: Album)
}

class PhotoVC: BaseVC {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var clvPhoto: UICollectionView!
    
    //MARK: - CONSTANTS
    
    private let viewBottomConstraint: CGFloat = 80
    
    //MARK: - UI
    
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
    
    
    //MARK: - PROPS
    
    weak var delegate: PhotoVCDelegate?
    
    var album: Album!
    var photos = [Photo]()
    
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
        clvPhoto.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: viewBottomConstraint, right: 0)
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
            if let index = album.index {
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
    
    private func deletePhotos(_ indexPaths: [IndexPath]) {
        guard let album = album,
              let albumIndex = album.index else {
            return
        }
        var isLastPhotoDeleted: Bool = false
        
        let indexes = indexPaths.map { $0.row }
        let sortedIndexes = indexes.sorted { $0 > $1 }
       
        SpinnerVC.show(on: self)
        DispatchQueue.background {
            for index in sortedIndexes {
                guard let photo = self.photos[safe: index] else {
                    continue
                }
                // If deleted photo is the last in the album
                if UserDefaultsStore.listAlbum[albumIndex].photos.last?.id == photo.id {
                    isLastPhotoDeleted = true
                }
                
                // Remove photo from document directory
                UIImage.clearPhotoCache(with: photo.id)
                
                // Update local data
                self.photos.remove(at: index)
                
                // Update UserDefaults
                UserDefaultsStore.listAlbum[albumIndex].photos.remove(at: index)
            }
        } completion: {
            SpinnerVC.hide()
            self.isEditingMode = false
            self.selectedIndex.removeAll()
            self.clvPhoto.reloadData()
            
            if isLastPhotoDeleted {
                self.delegate?.didUpdatePhotos(in: album)
            }
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

//MARK: - UICollectionViewDelegate
extension PhotoVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            
            let headerView = PhotoViewerHeaderView()
            headerView.delegate = self
            
            let viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)
            viewerController.modalTransitionStyle = .crossDissolve
            viewerController.dataSource = self
            viewerController.delegate = self
            viewerController.footerView = toolBar
            viewerController.headerView = headerView
            viewerController.viewableBackgroundColor = theme.background
            present(viewerController, animated: false, completion: nil)
        }
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

//MARK: - ViewerControllerDelegate
extension PhotoVC: ViewerControllerDelegate {
    
    func viewerController(_ viewerController: Viewer.ViewerController, didChangeFocusTo indexPath: IndexPath) {
        if let header = viewerController.headerView as? PhotoViewerHeaderView {
            header.setSelectedItem(indexPath)
        }
        if let toolBar = viewerController.footerView as? ToolBarView {
            toolBar.setItems([indexPath])
        }
    }
    
    func viewerControllerDidDismiss(_ viewerController: Viewer.ViewerController) {}
    
    func viewerController(_ viewerController: Viewer.ViewerController, didFailDisplayingViewableAt indexPath: IndexPath, error: NSError) {}
    
    func viewerController(_ viewerController: Viewer.ViewerController, didLongPressViewableAt indexPath: IndexPath) {}
}

//MARK: - PhotoViewerHeaderViewDelegate
extension PhotoVC: PhotoViewerHeaderViewDelegate {
    
    func didTapClose(_ controller: UIViewController) {
        guard let vc = controller as? ViewerController else {
            return
        }
        vc.dismiss(nil)
    }
    
    func didTapEdit(_ controller: UIViewController, for indexPath: IndexPath) {
        guard let viewerController = controller as? ViewerController,
              let image = photos[indexPath.row].image else {
            return
        }
        let imageProvider = ImageProvider(image: image)
        
        let editingStack = EditingStack(imageProvider: imageProvider)
        
        let options = ClassicImageEditOptions.default
        
        let editController = ClassicImageEditViewController(editingStack: editingStack, options: options)
        
        let navigationController = UINavigationController(rootViewController: editController)
        navigationController.modalPresentationStyle = .fullScreen

        // Handlers
        editController.handlers.didCancelEditing = { vc in
            navigationController.dismiss(animated: true)
        }
        editController.handlers.didEndEditing = { [weak self] vc, editStack in
            guard let self = self else { return }
            var image: UIImage?
            
            do {
                let rendered = try editStack.makeRenderer().render()
                let imgData = rendered.makeOptimizedForSharingData(dataType: .png)
                image = UIImage(data: imgData)
            } catch {
                print("error?", error)
            }
            
            if let image = image {
                self.photos[indexPath.row].saveImage(image: image)
                self.photos[indexPath.row].saveThumbnail(with: image)
                self.clvPhoto.reloadData()
                navigationController.dismiss(animated: true)
            }
        }
        
        // Show edit screen
        viewerController.dismiss { [weak self] in
            self?.present(navigationController, animated: true, completion: nil)
        }
    }
}

//MARK: - ToolBarViewDelegate
extension PhotoVC: ToolBarViewDelegate {
  
    func didTapShare(_ toolBarView: ToolBarView, controller: UIViewController, for indexes: [IndexPath]) {
        let shareItems = photos.compactMap { $0.image }
        let shareController = UIActivityViewController(
            activityItems: shareItems as [Any],
            applicationActivities: nil
        )
        controller.present(shareController, animated: true)
    }
    
    func didTapDelete(_ toolBarView: ToolBarView, controller: UIViewController, for indexes: [IndexPath]) {
        let alertTitle = selectedIndex.count > 1 ? "photos" : "photo"
        AlertView.showAlert(
            controller,
            title: "Delete \(alertTitle)",
            message: "Are you sure you want to delete?",
            actions: [
                UIAlertAction(title: "Cancel", style: .cancel),
                UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                    self?.deletePhotos(indexes)
                    controller.dismiss(animated: true)
                })
            ]
        )
    }
    
    func didTapInfo(_ toolBarView: ToolBarView, controller: UIViewController, for index: IndexPath) {
        guard let photo = photos[safe: index.row] else {
            return
        }
        let vc = PhotoInfoVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.setupData(photo: photo)

        controller.present(vc, animated: false)
    }
}
