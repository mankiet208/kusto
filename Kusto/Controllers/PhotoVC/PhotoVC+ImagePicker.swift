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
            
            DispatchQueue.background {
                self.updateImageStorage(images: images)
            } completion: {
                // Remove import photo in library

                // Update UI
                self.clvPhoto.reloadData()
                
                // Prompt user to remove photo in trash
                AlertView.showAlert(self, title: "Import Completed", message: "")
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
        guard let album = album else {
            return
        }
        for image in images {
            let imageName = UUID().uuidString
            let imagePath = UIImage.getDocumentsDirectory().appendingPathComponent(imageName)
                    
            // Write photo to documents directory
            if let jpegData = image.jpegData(compressionQuality: 1) {
                try? jpegData.write(to: imagePath)
            }
            
            // Update album model in UserDefaults
            let photo = Photo(
                id: UUID().uuidString,
                albumId: album.id,
                name: imageName
            )
            photo.saveThumbnail(with: image)
            photos.append(photo)
        }
        if let index = UserDefaultsStore.listAlbum.firstIndex(where: {$0.id == album.id}) {
            UserDefaultsStore.listAlbum[index].photos = photos
        }
    }
}
