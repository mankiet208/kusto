//
//  CollectionViewDataSource.swift
//  Kusto
//
//  Created by Kiet Truong on 3/9/21.
//

import UIKit

class CollectionViewDataSource<Model>: NSObject, UICollectionViewDataSource {
    
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void
    
    var models: [Model] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let reuseIdentifier: String
    private let collectionView: UICollectionView
    private let cellConfigurator: CellConfigurator
    
    init(
        models: [Model],
        reuseIdentifier: String,
        collectionView: UICollectionView,
        cellConfigurator: @escaping CellConfigurator
    ) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.collectionView = collectionView
        self.cellConfigurator = cellConfigurator
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let model = models[indexPath.row]
        cellConfigurator(model, cell)
        return cell
    }
}

