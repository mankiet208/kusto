//
//  PhotoVC+logic.swift
//  Kusto
//
//  Created by Kiet Truong on 06/06/2024.
//

import UIKit

extension PhotoVC {
    
    func addPhotos(images: [UIImage]) {
        guard let album = album,
              let albumIndex = album.index else {
            return
        }
        for image in images {
            let imageId = UUID().uuidString
            let imagePath = UIImage.getDocumentsDirectory().appendingPathComponent(imageId)

            // Write photo to documents directory
            if let data = image.jpegData(compressionQuality: 0.8) {
                try? data.write(to: imagePath)
            }

            // Update album model in UserDefaults
            let photo = Photo(
                id: imageId,
                albumId: album.id
            )
            photo.saveThumbnail(with: image)
            photos.append(photo)
            UserDefaultsStore.listAlbum[albumIndex].photos.append(photo)
        }
    }
    
    func deletePhotos(_ indexPaths: [IndexPath]) {
        guard let album = album,
              let albumIndex = album.index else {
            return
        }
        var isLastPhotoDeleted: Bool = false

        let indexes = indexPaths.map { $0.row }
        let sortedIndexes = indexes.sorted { $0 > $1 }

        SpinnerVC.show(on: self)
        
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
        
        SpinnerVC.hide()
        
        self.isEditingMode = false
        self.selectedIndex.removeAll()
        self.clvPhoto.deleteItems(at: indexPaths)

        if isLastPhotoDeleted {
            self.delegate?.didUpdatePhotos(in: album)
        }
    }
}


