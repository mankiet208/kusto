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
                self.updateImageStorage(images: images)
            } completion: {
                SpinnerVC.hide()
                
                // Update UI
                self.clvPhoto.reloadData()
                
                // TODO: Remove import photo in library
                
                // TODO: Prompt user to remove photo in trash
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
    
    func updateImageStorage(images: [UIImage]) {
        guard let album = album,
              let albumIndex = album.getIndex() else {
            return
        }
        for image in images {
            let imageId = UUID().uuidString
            let imagePath = UIImage.getDocumentsDirectory().appendingPathComponent(imageId)
                    
            // Write photo to documents directory
            if let jpegData = image.jpegData(compressionQuality: 1) {
                try? jpegData.write(to: imagePath)
            }
            
            // Update album model in UserDefaults
            let photo = Photo(
                id: imageId,
                albumId: album.id
            )
            photo.saveThumbnail(with: image)
            photos.append(photo)
            UserDefaultsStore.listAlbum[albumIndex].photos.append(photo)
            delegate?.didUpdatePhotos(in: album)
        }
    }
}
