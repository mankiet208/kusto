//
//  AlbumCellViewModel.swift
//  Kusto
//
//  Created by Mac on 3/9/21.
//

import UIKit

struct AlbumCellViewModel {
    let name: String?
    let avatarImage: UIImage?
    
    init(from album: Album) {
        self.name = album.name
        
        if let image = album.photos.last?.image {
            self.avatarImage = image
        } else {
            self.avatarImage = nil
        }
    }
}
