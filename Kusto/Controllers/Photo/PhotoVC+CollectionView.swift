//
//  PhotoVC+CollectionView.swift
//  Kusto
//
//  Created by Kiet Truong on 06/06/2024.
//

import UIKit
import Viewer

//MARK: - UICollectionViewDataSource
extension PhotoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath)
                as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let photo = photos[indexPath.row]
        let photoVM = PhotoCellViewModel(from: photo)
        cell.configure(with: photoVM, for: indexPath)
        
        let isCellSelected = selectedIndex.contains(indexPath)
        cell.toggleSelected(isCellSelected)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth / 3 - 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

//MARK: - UICollectionViewDelegate
extension PhotoVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingMode {
            guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {
                return
            }
            if selectedIndex.contains(indexPath) {
                // Unselect
                if let index = selectedIndex.firstIndex(where: { $0 == indexPath }) {
                    selectedIndex.remove(at: index)
                }
                cell.toggleSelected(false)
            } else {
                // Select
                selectedIndex.append(indexPath)
                cell.toggleSelected(true)
            }
        } else {
            // Show photo viewer
            let toolBar = ToolBarView()
            toolBar.delegate = self
            
            let headerView = PhotoViewerHeaderView()
            headerView.delegate = self
            
            let viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)
            viewerController.modalTransitionStyle = .crossDissolve
            viewerController.dataSource = self
            viewerController.delegate = self
            viewerController.footerView = toolBar
            viewerController.headerView = headerView
            viewerController.viewableBackgroundColor = theme.background
            present(viewerController, animated: false, completion: nil)
        }
    }
}
