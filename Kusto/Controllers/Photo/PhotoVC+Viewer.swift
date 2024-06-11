//
//  PhotoVC+Viewer.swift
//  Kusto
//
//  Created by Kiet Truong on 06/06/2024.
//

import UIKit
import Viewer
import BrightroomUI

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
        let editController = PhotosCropViewController(imageProvider: .init(image: image))
        editController.modalPresentationStyle = .fullScreen
        
        // Handlers
        editController.handlers.didCancel = { vc in
            editController.dismiss(animated: true)
        }
        editController.handlers.didFinish = { [weak self] vc in
            guard let self = self else { return }
            var image: UIImage?
            let editingStack = vc.editingStack
            
            do {
                let rendered = try editingStack.makeRenderer().render()
                let imgData = rendered.makeOptimizedForSharingData(dataType: .png)
                image = UIImage(data: imgData)
            } catch {
                Logger.error(error.localizedDescription)
            }
            
            if let image = image {
                self.photos[indexPath.row].saveImage(image: image)
                self.photos[indexPath.row].saveThumbnail(with: image)
                self.clvPhoto.reloadData()
                editController.dismiss(animated: true)
            }
        }
        
        // Show edit screen
        viewerController.dismiss { [weak self] in
            self?.present(editController, animated: true, completion: nil)
        }
    }
}
