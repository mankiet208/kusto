//
//  PhotoCellViewModel.swift
//  Kusto
//
//  Created by Mac on 3/9/21.
//

import UIKit

struct PhotoCellViewModel {
    let id: String
    let image: UIImage?
    
    init(from model: Photo) {
        self.id = model.id
        self.image = model.thumbnail
    }
}
