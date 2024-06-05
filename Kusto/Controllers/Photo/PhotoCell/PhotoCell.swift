//
//  PhotoCell.swift
//  Kusto
//
//  Created by kiettruong on 18/03/2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var imgSelect: UIImageView!
    
    var indexPath: IndexPath!
        
    override func awakeFromNib() {
        super.awakeFromNib()
                
        imgPhoto.backgroundColor = .primary
    }
    
    func configure(with photoVM: PhotoCellViewModel, for indexPath: IndexPath) {
        imgPhoto.image = photoVM.image
        self.indexPath = indexPath
    }
    
    func toggleSelected(_ flag: Bool) {
        if flag {
            imgSelect.isHidden = false
        } else {
            imgSelect.isHidden = true
        }
    }
}

extension PhotoCell {
    static let identifier: String = "PhotoCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PhotoCell", bundle: nil)
    }
}
