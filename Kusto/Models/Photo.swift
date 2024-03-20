//
//  File.swift
//  Kusto
//
//  Created by Mac on 3/9/21.
//

import UIKit
import Viewer

struct Photo: Codable {
    let albumId: String
    let name: String
    
    func saveThumbnail(with image: UIImage) {
        if let resizedImage = image.resizeImage(newWidth: 200) {
            UserDefaults.standard.set(resizedImage.pngData(), forKey: name)
        }
    }
    
    func loadThumbnail() -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: name) as? Data,
            let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: name)
        }
    }

    func load() -> Photo? {
        guard let photoData = UserDefaults.standard.object(forKey: name) as? Data else {
           return nil
        }
        let decoder = JSONDecoder()
        let photo = try? decoder.decode(Photo.self, from: photoData)
        return photo
    }
}

extension Photo {
    func toUIImage() -> UIImage? {
        let imagePath = UIImage.getDocumentsDirectory().appendingPathComponent(self.name).path
        return UIImage(contentsOfFile: imagePath)
    }
}

struct ViewablePhoto: Viewable {
    let type: Viewer.ViewableType
    let assetID: String?
    let url: String?
    let placeholder: UIImage
    
    func media(_ completion: @escaping (UIImage?, NSError?) -> Void) {
        
    }
}
