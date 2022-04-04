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
    
//    init(playlists: [Playlist]){
//        super.init(nibName: nil, bundle: nil)
//        self.playlists = playlists
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("Debug: library playlist view didLayout")
        //view.backgroundColor = .systemPink
        
        collectionView.register(FeaturePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    func configure(with playlists: [UserPlaylist]){
        self.playlists = playlists
        
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
        
        
    }
    
    
}
