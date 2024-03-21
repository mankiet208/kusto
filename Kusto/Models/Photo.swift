//
//  File.swift
//  Kusto
//
//  Created by Mac on 3/9/21.
//

import UIKit
import Viewer

struct Photo: Codable {
    let id: String
    let albumId: String
    let name: String
    
    var image: UIImage? {
        let imagePath = UIImage.getDocumentsDirectory().appendingPathComponent(self.name).path
        return UIImage(contentsOfFile: imagePath)
    }
    
    var thumbnail: UIImage? {
        guard let imageData = UserDefaults.standard.object(forKey: name) as? Data,
              let image = UIImage(data: imageData) else  {
            return nil
        }
        return image
    }
    
    var imageSize: String {
        guard let data = image?.pngData() else {
            return "Error size"
        }
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(data.count))
        return string
    }
    
    func saveThumbnail(with image: UIImage) {
        if let resizedImage = image.resizeImage(newWidth: 200) {
            UserDefaults.standard.set(resizedImage.pngData(), forKey: name)
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: name)
        }
    }
}

extension Photo {
    
    var viewable: Viewable {
        get {
            return ViewablePhoto(
                type: .image,
                assetID: id,
                url: nil,
                placeholder: image ?? UIImage(named: "img_placeholder")!
            )
        }
    }
}

struct ViewablePhoto: Viewable {
    let type: Viewer.ViewableType
    let assetID: String?
    let url: String?
    let placeholder: UIImage

    func media(_ completion: @escaping (UIImage?, NSError?) -> Void) {}
}


