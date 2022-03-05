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
    
    private var viewModels: [RecommendationCellViewModel]?
    
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
                    
                    self?.collectionView.reloadData()
                
                case .failure(_):
                    break
                }
            }
        }
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
                heightDimension: .fractionalHeight(0.1)),
            subitem: item,
            count: 1)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell, let viewModel = viewModels?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    
}
