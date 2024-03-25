//
//  AlbumVC.swift
//  Kusto
//
//  Created by Mac on 3/5/21.
//

import UIKit

class AlbumVC: BaseVC {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var tbvAlbum: UITableView!
    
    //MARK: - PROPS
    
    var albums: [Album] = UserDefaultsStore.listAlbum
    
    //MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Album"
        
        setupTableView()
    }
    
    //MARK: - CONFIG
    
    private func setupTableView() {
        tbvAlbum.register(AlbumCell.nib(), forCellReuseIdentifier: AlbumCell.identifier)
        
        tbvAlbum.dataSource = self
        tbvAlbum.delegate = self
        
        tbvAlbum.alwaysBounceVertical = true
        tbvAlbum.separatorColor = .clear
        tbvAlbum.backgroundColor = .clear
    }
    
    override func setupRightBarButton() {
        let backButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        backButtonItem.tintColor = .primary
        navigationItem.rightBarButtonItem = backButtonItem
    }
    
    @objc func didTapRightBarButton() {
        let alertVC = UIAlertController(
            title: "Add album",
            message: "Input album name",
            preferredStyle: .alert
        )
        alertVC.addTextField { textField in
            textField.placeholder = "Album name"
        }
        let saveAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alertVC] action in
            guard let text = alertVC?.textFields?.first?.text else {
                return
            }
            self?.addAlbum(with: text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true)
    }
    
    private func addAlbum(with name: String) {
        guard !name.isEmpty else {
            return
        }
        let album = Album(name: name, photos: [])
        albums.append(album)
        UserDefaultsStore.listAlbum.append(album)
        tbvAlbum.reloadData()
    }
    
    private func removeAlbum(at indexPath: IndexPath) {
        guard !albums.isEmpty else {
            return
        }
        let album = albums[indexPath.row]
        
        let alertVC = UIAlertController(
            title: "Delete \"\(album.name)\"",
            message: "Are you sure you want to delete the album \"\(album.name)\"?",
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(title: "Delete Album", style: .destructive) { [weak self] action in
            guard let self = self else {
                return
            }
            self.albums.remove(at: indexPath.row)
            self.tbvAlbum.deleteRows(at: [indexPath], with: .fade)
            UserDefaultsStore.listAlbum.remove(at: indexPath.row)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    private func refresh() {
        albums = UserDefaultsStore.listAlbum
        tbvAlbum.reloadData()
    }
}

extension AlbumVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        let albumVM = AlbumCellViewModel(from: album)
        cell.configure(with: albumVM)
        return cell
    }
}

extension AlbumVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let photoVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotoVC") as? PhotoVC else {
            return
        }
        photoVC.delegate = self
        photoVC.album = albums[indexPath.row]
        self.push(photoVC)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 && albums[indexPath.row].name == "Main" {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        if editingStyle == .delete {
            removeAlbum(at: indexPath)
        } else if editingStyle == .insert {
            
        }
    }
}

extension AlbumVC: PhotoVCDelegate {
    
    func didUpdatePhotos(in album: Album) {
        refresh()
    }
}
