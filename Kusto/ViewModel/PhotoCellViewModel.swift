//
//  PhotoCellViewModel.swift
//  Kusto
//
//  Created by Mac on 3/9/21.
//

import UIKit

struct PhotoCellViewModel {
    let name: String
    let image: UIImage?
    
    init(from model: Photo) {
        self.name = model.name
        self.image = model.loadThumbnail()
    }
}
