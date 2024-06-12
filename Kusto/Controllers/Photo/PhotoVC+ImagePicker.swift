//
//  PhotoVC+ImagePicker.swift
//  Kusto
//
//  Created by kiettruong on 05/04/2021.
//

import UIKit
import Photos
import BSImagePicker

extension PhotoVC {
    
    func showImagePicker() {
        let imagePicker = ImagePickerController()
        
        presentImagePicker(
            imagePicker,
            select: { (asset) in
                // User selected an asset. Do something with it. Perhaps begin processing/upload?
            }, deselect: { (asset) in
                // User deselected an asset. Cancel whatever you did when asset was selected.
            }, cancel: { (assets) in
                // User canceled selection.
            }, finish: { (assets: [PHAsset]) in
            // User finished selection assets.
                let images: [UIImage] = self.getImageFromAsset(assets: assets)
                
                SpinnerVC.show(on: self)
                
                self.addPhotos(images: images)

                SpinnerVC.hide()

                // Update UI
                self.clvPhoto.reloadData()

                // Update album
                self.delegate?.didUpdatePhotos(in: self.album)

                // Delete original photos in Photos app
                self.promptToDeleteOriginalPhoto(assets)
            }
        )
    }
    
    private func getImageFromAsset(assets: [PHAsset]) -> [UIImage] {
        var arrImages = [UIImage]()
        
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            
            option.isSynchronous = true
            
            manager.requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: option
            ) { (image, info) in
                if let image = image {
                    arrImages.append(image)
                }
            }
        }
        
        return arrImages
    }
    
    private func promptToDeleteOriginalPhoto(_ assets: [PHAsset], completionHandler: (() -> Void)? = nil) {
        AlertView.showAlert(
            self,
            title: LocalizationKey.deleteOriginPhotosTitle.localized(),
            message: LocalizationKey.deleteOriginPhotosMessage.localized(),
            actions: [
                UIAlertAction(
                    title: LocalizationKey.cancel.localized(),
                    style: .default,
                    handler: { _ in
                    completionHandler?()
                }),
                
                UIAlertAction(
                    title: LocalizationKey.delete.localized(),
                    style: .destructive,
                    handler: { _ in
                                  
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
                    }) { success, error in
                        if success {
                            print("success")
                        } else {
                            print(error!)
                        }
                        completionHandler?()
                    }
                                  
                })
            ]
        )
    }
}
