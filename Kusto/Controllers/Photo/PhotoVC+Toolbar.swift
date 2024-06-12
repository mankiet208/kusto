//
//  PhotoVC+Toolbar.swift
//  Kusto
//
//  Created by Kiet Truong on 06/06/2024.
//

import UIKit

//MARK: - ToolBarViewDelegate
extension PhotoVC: ToolBarViewDelegate {
    
    func didTapShare(_ toolBarView: ToolBarView, controller: UIViewController, for indexPaths: [IndexPath]) {
        let shareItems = photos.compactMap { $0.image }
        let shareController = UIActivityViewController(
            activityItems: shareItems as [Any],
            applicationActivities: nil
        )
        controller.present(shareController, animated: true)
    }
    
    func didTapDelete(_ toolBarView: ToolBarView, controller: UIViewController, for indexPaths: [IndexPath]) {
        AlertView.showAlert(
            controller,
            title: LocalizationKey.deletePhotosTitle.localized(),
            message: LocalizationKey.deletePhotosMessage.localized(),
            actions: [
                UIAlertAction(title: LocalizationKey.cancel.localized(), style: .cancel),
                
                UIAlertAction(
                    title: LocalizationKey.delete.localized(),
                    style: .destructive,
                    handler: { [weak self] _ in
                        
                    self?.deletePhotos(indexPaths)
                    controller.dismiss(animated: true)
                })
            ]
        )
    }
    
    func didTapInfo(_ toolBarView: ToolBarView, controller: UIViewController, for indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.row] else {
            return
        }
        let vc = PhotoInfoVC()
        vc.setupData(photo: photo)
        
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        controller.present(nav, animated: true)
    }
}
