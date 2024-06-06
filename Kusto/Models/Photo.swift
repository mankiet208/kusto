//
//  File.swift
//  Kusto
//
//  Created by Kiet Truong on 3/9/21.
//

import UIKit
import Viewer

struct Photo: Codable {
    let id: String
    let albumId: String
    
    // PRIVATE
    
    private var thumbnailID: String {
        return "thumbnail_\(id)"
    }
    
    private var photoID: String {
        return "photo_\(id)"
    }
    
    private var url: URL {
        return UIImage.getDocumentsDirectory().appendingPathComponent(id)
    }
    
    // PUBLIC
    
    var data: Data? {
        return try? Data(contentsOf: url, options: [])
    }
    
    var image: UIImage? {
        return UIImage(contentsOfFile: url.path)
    }
    
    var thumbnail: UIImage? {
        guard let imageData = UserDefaults.standard.object(forKey: thumbnailID) as? Data,
              let image = UIImage(data: imageData) else  {
            return nil
        }
        return image
    }
    
    var size: String? {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let fileSize = attributes[FileAttributeKey.size] as? UInt64 else {
            return nil
        }
        return "\(fileSize / 1024)"
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: photoID)
        }
    }
    
    func saveThumbnail(with image: UIImage) {
        if let resizedImage = image.resizeImage(newWidth: 200) {
            UserDefaults.standard.set(resizedImage.pngData(), forKey: thumbnailID)
        }
    }
    
    func saveImage(image: UIImage, compression: CGFloat = 1) {
        if let jpegData = image.jpegData(compressionQuality: 1) {
            try? jpegData.write(to: url)
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



extension URL {
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
