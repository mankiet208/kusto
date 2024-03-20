//
//  UserDefaultsStore.swift
//  Kusto
//
//  Created by Mac on 3/10/21.
//

import Foundation

struct UserDefaultsStore {
    @UserDefaultsWrapper("has_launch_before", defaultValue: false)
    static var hasLaunchBefore: Bool
    
    @UserDefaultsWrapper("list_album", defaultValue: [])
    static var listAlbum: [Album]
}
