//
//  AlbumCell.swift
//  Kusto
//
//  Created by Mac on 3/5/21.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
                
        imvAvatar.backgroundColor = .primary
    }
    
    func configure(with albumVM: AlbumCellViewModel) {
        lblTitle.text = albumVM.name
        imvAvatar.image = albumVM.avatarImage
    }
}

extension AlbumCell {
    static let identifier: String = "AlbumCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AlbumCell", bundle: nil)
    }
}
