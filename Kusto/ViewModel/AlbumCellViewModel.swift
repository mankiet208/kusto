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
    
    init(from model: Album) {
        self.name = model.name
        
        if let image = model.photos.last?.image {
            self.avatarImage = image
        } else {
            self.avatarImage = nil
        }
    }
}
