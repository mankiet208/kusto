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
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished selection assets.
            let images = self.getImageFromAsset(assets: assets)
            
            SpinnerVC.show(on: self)
            
            DispatchQueue.background {
                self.addPhotos(images: images)
            } completion: {
                SpinnerVC.hide()
                
                // Update UI
                self.clvPhoto.reloadData()
                
                // TODO: Remove import photo in library
                
                // TODO: Prompt user to remove photo in trash
                
                // Update album
                self.delegate?.didUpdatePhotos(in: self.album)
            }
        })
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
}
