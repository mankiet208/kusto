//
//  PhotoCell.swift
//  Kusto
//
//  Created by kiettruong on 18/03/2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    lazy private var imgSelected: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var indexPath: IndexPath!
        
    override func awakeFromNib() {
        super.awakeFromNib()
                
        setupView()
    }
    
    private func setupView() {
        imgPhoto.backgroundColor = .primary

        contentView.addSubview(imgSelected)
        
        NSLayoutConstraint.activate([
            imgSelected.widthAnchor.constraint(equalToConstant: 24),
            imgSelected.heightAnchor.constraint(equalToConstant: 24),
            imgSelected.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imgSelected.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(with photoVM: PhotoCellViewModel, for indexPath: IndexPath) {
        imgPhoto.image = photoVM.image
        self.indexPath = indexPath
    }
    
    func toggleSelected(_ flag: Bool) {
        if flag {
            imgSelected.isHidden = false
        } else {
            imgSelected.isHidden = true
        }
    }
}

extension PhotoCell {
    static let identifier: String = "PhotoCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PhotoCell", bundle: nil)
    }
}
