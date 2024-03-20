//
//  KeyboardView.swift
//  Kusto
//
//  Created by Kiet Truong on 19/03/2024.
//

import UIKit

protocol KeyboardViewDelegate: AnyObject {
    func didTapNumberKey(_ key: Int)
    func didTapBiometric()
    func didTapDelete()
}

class KeyboardView: UIView {
    
    //MARK: - CONSTANT
    
    let numberOfItemsPerRow: CGFloat = 3
    let buttonHeight: CGFloat = 50
    
    //MARK: - UI
    
    private lazy var gridView: UICollectionView = {
        let gridView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()
    
    //MARK: - PROPS
    
    weak var delegate: KeyboardViewDelegate?
        
    //MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONFIG
    
    private func setupView() {
        backgroundColor = theme.background
    }
    
    private func setUpCollectionView() {
        addSubview(gridView)
        gridView.pinEdgesToSuperView()
        gridView.register(KeyboardCell.self, forCellWithReuseIdentifier: KeyboardCell.identifier)
        gridView.delegate = self
        gridView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        
        gridView.setCollectionViewLayout(layout, animated: true)
        gridView.backgroundColor = theme.background
    }
    
    //MARK: - FUNCTION
    
    @objc private func buttonAction(sender: UIButton!) {
        print(sender.tag)
    }
}

extension KeyboardView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyboardCell.identifier,
                                                            for: indexPath) as? KeyboardCell else {
            return UICollectionViewCell()
        }
        
        let keyboardIndex = indexPath.row + 1
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
        
        switch (keyboardIndex) {
        case 10:
            cell.btnKeyboard.setImage(UIImage(systemName: "touchid", withConfiguration: imageConfig), for: .normal)
        case 11:
            cell.btnKeyboard.setTitle("0", for: .normal)
        case 12:
            cell.btnKeyboard.setImage(UIImage(systemName: "delete.backward", withConfiguration: imageConfig), for: .normal)
        default:
            cell.btnKeyboard.setTitle("\(keyboardIndex)", for: .normal)
        }

        return cell
    }
}

extension KeyboardView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 8.0, bottom: 1.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / numberOfItemsPerRow - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 8, height: 50)
    }
    
     func collectionView(_ collectionView: UICollectionView,
                         didHighlightItemAt indexPath: IndexPath) {
         UIView.animate(withDuration: 0.2) {
             if let cell = collectionView.cellForItem(at: indexPath) as? KeyboardCell {
                 cell.contentView.backgroundColor = .gray800
             }
         }
    }

     func collectionView(_ collectionView: UICollectionView,
                         didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? KeyboardCell {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row + 1
        switch (index) {
        case 10:
            delegate?.didTapBiometric()
        case 11:
            delegate?.didTapNumberKey(0)
        case 12:
            delegate?.didTapDelete()
        default:
            delegate?.didTapNumberKey(index)
        }
    }
}
