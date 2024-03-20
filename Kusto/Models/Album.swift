//
//  File.swift
//  Kusto
//
//  Created by Mac on 3/9/21.
//

import Foundation

struct Album: Codable {
    let id: String
    let name: String
    var photos: [Photo]
    
    init(name: String, photos: [Photo]) {
        id = UUID().uuidString
        self.name = name
        self.photos = photos
    }
}
