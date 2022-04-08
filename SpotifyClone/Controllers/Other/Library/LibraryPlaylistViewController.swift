//
//  LibraryPlaylistViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 30/3/2022.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
        LibraryPlaylistViewController.createLayoutSection()
    }))
    
    private var playlists = [UserPlaylist]()
    public var selectionHandler: ((UserPlaylist) -> Void)?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("Debug: library playlist view didLayout")
        //view.backgroundColor = .systemPink
        
        collectionView.register(FeaturePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            switch result{
            case .success(let userPlaylists):
                self?.configure(with: userPlaylists.items)
            case .failure(_):
                print("Debug: cannot get user playlists")
            }
        }
        
        if selectionHandler != nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        }
        
    }
    
    @objc func didTapClose(){
        dismiss(animated: true)
    }
    
    static func createLayoutSection() -> NSCollectionLayoutSection{
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25)), subitem: item, count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }

}

extension LibraryPlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturePlaylistCollectionViewCell else{
            print("Debug: vanilla cell loaded")
            return UICollectionViewCell()
        }
        
        let userPlaylist = playlists[indexPath.row]
        
        cell.configure(with: FeaturePlaylistCellViewModel(name: userPlaylist.name,
                                                          imageURL: URL(string: userPlaylist.images.first?.url ?? ""),
                                                          creatorName: userPlaylist.owner.display_name))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        APICaller.shared.getPlaylistTracks(with: playlist.id) {[weak self] result in
            guard self?.selectionHandler == nil else{
                self?.selectionHandler!(playlist)
                return
            }
            
            DispatchQueue.main.async {
                let playlist = Playlist(description: playlist.description, external_urls: [:], href: "", id: playlist.id, images: playlist.images, name: playlist.name, owner: playlist.owner, snapshot_id: playlist.snapshot_id, tracks: Tracks(href: "", total: 0), type: "", uri: "")
                let vc = PlaylistViewController(playlist: playlist)
                vc.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    
    func configure(with playlists: [UserPlaylist]){
        self.playlists = playlists
        
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    
}
