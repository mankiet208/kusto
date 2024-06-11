//
//  LocalizationKey.swift
//  Kusto
//
//  Created by Kiet Truong on 10/06/2024.
//

import Foundation



struct LocalizationKey {
    
    // General
    static let ok = "ok"
    static let cancel = "cancel"
    static let reset = "reset"
    static let delete = "delete"
    static let edit = "edit"
    static let openSettings = "open_settings"
    static let areYouSure = "are_you_sure"
    static let size = "size"
    static let forrmat = "format"
    static let info = "info";
    
    // Auth
    static let pleaseEnterYourPin = "please_enter_your_pin"
    static let pleaseSetupYourPin = "please_setup_your_pin"
    static let biometricEnrollTitle = "biometric_enroll_title"
    static let biometricEnrollMessage = "biometric_enroll_message"
    static let changeYourPin = "change_your_pin"
    static let chooseNewPin = "choose_new_pin"
    static let pinHasChanged = "pin_has_changed"
    
    // Title
    static let album = "album"
    static let settings = "settings"
    
    // Album
    static let mainAlbum = "main_album"
    static let albumName = "album_name"
    static let addAlbumTitle = "add_album_title"
    static let addAlbumMessage = "add_album_message"
    static let deleteAlbumTitle = "delete_album_title"
    static let deleteAlbumMessage = "delete_album_message"
    
    // Photos
    static let numSelectedPhoto = "num_selected_photo"
    static let photosPermisionTitle = "photos_permission_title"
    static let photosPermissionMessage = "photos_permission_message"
    static let deleteOriginPhotosTitle = "delete_origin_photos_title"
    static let deleteOriginPhotosMessage = "delete_origin_photos_message"
    static let deletePhotosTitle = "delete_photos_title"
    static let deletePhotosMessage = "delete_photos_message"

    // Setting
    static let biometric = "biometric"
    static let changePinCode = "change_pin_code"
    static let share = "share_app"
    static let version = "version"
}

extension String {
    
    func localized(_ arguments: [CVarArg] = []) -> String {
        return String(format: NSLocalizedString(self, comment: ""), locale: nil, arguments: arguments)
    }
}
