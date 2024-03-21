//
//  PermissionHelper.swift
//  Kusto
//
//  Created by Kiet Truong on 21/03/2024.
//

import UIKit
import Photos

class PermissionHelper {
    
    static let shared = PermissionHelper()
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
         }
         if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
         }
    }
}

//MARK: PHOTOS
extension PermissionHelper {
    
    func checkPhotos(completion: @escaping ((Bool) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch (status) {
        case .notDetermined:
            requestPhotos() { granted in
                completion(granted)
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
    
    private func requestPhotos(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization({ status in
            completion(status == .authorized)
        })
    }
}
