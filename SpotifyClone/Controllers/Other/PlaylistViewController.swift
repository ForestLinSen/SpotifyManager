//
//  PlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 2/3/2022.
//

import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {sectionIndex, _ in
        PlaylistViewController.createCollectionLayout()
    }))
    
    private var viewModels = [RecommendationCellViewModel]()
    private var headerViewModel: PlaylistHeaderViewModel?
    
    init(playlist: Playlist){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getPlaylistDetail(playlistID: playlist.id) {[weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlistResponse):
                    self?.viewModels = playlistResponse.tracks.items.compactMap { playlistTrack in
                        RecommendationCellViewModel(trackName: playlistTrack.track.name,
                                                    artistName: playlistTrack.track.artists.first?.name ?? "-",
                                                    imageURL: URL(string: playlistTrack.track.album.images.first?.url ?? ""))
                        
                        
                    }
                    
                    self?.headerViewModel = PlaylistHeaderViewModel(name: playlistResponse.name,
                                                              owner: playlistResponse.owner.display_name,
                                                              description: playlistResponse.description,
                                                              imageURL: playlistResponse.images.first?.url ?? "")
                    
                case .failure(_):
                    break
                }
                
                self?.collectionView.reloadData()
            }
            
            
        }
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    static func createCollectionLayout() -> NSCollectionLayoutSection{
        // item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.15)),
            subitem: item,
            count: 1)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        // boundary items such as footer and
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.2)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        return section
    }
    
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView else {
                  return UICollectionReusableView()
              }
        
        if let viewModel = headerViewModel{
            header.configure(with: viewModel)
        }
   
        return header
 
    }
    
    
}
