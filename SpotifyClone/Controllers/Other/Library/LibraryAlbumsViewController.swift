//
//  LibraryAlbumsViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 30/3/2022.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
        LibraryAlbumsViewController.createCollectionViewLayout()
    }))
    
    private var albums = [Album]()
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        view.addSubview(collectionView)
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //APICaller.shared.
        fetchData()
        
        
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: {[weak self] _ in
            self?.fetchData()
        })
    }
    
    private func fetchData(){
        self.albums.removeAll()
        APICaller.shared.getUserSavedAlbums {[weak self] result in
            switch result{
                
            case .success(let albums):
                
                DispatchQueue.main.async {
                    self?.albums = albums.items.compactMap({ libraryAlbum in
                        return libraryAlbum.album
                    })
                    self?.collectionView.reloadData()
                }
                
                
                
            case .failure(_):
                break
            }
        }
    }
    

    
    static func createCollectionViewLayout() -> NSCollectionLayoutSection{
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        // group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                        NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .fractionalHeight(0.15)),
                                                       subitem: item, count: 2)
        
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


extension LibraryAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let album = albums[indexPath.row]
        let viewModel = RecommendationCellViewModel(trackName: album.name, artistName: album.artists.first?.name ?? "", imageURL: URL(string: album.images.first?.url ?? ""))
        cell.configure(with: viewModel)
        return cell
                
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
