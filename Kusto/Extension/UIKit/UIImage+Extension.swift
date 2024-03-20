//
//  UIImage+Extension.swift
//  Kusto
//
//  Created by kiettruong on 18/03/2021.
//

import UIKit

extension UIImage {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func clearAllCache() {
        let fileManager = FileManager.default
        do {
            let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURLs = try fileManager.contentsOfDirectory(
                at: documentURL,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            for url in fileURLs {
               try fileManager.removeItem(at: url)
            }
        } catch {
            print(error)
        }
    }
    
    static func clearPhotoCache(photoId: String) {
        let fileManager = FileManager.default
        do {
            let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let photoURL = documentURL.appendingPathComponent(photoId)
            try fileManager.removeItem(at: photoURL)
        } catch {
            print(error)
        }
      }
    
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImageView {
    
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
