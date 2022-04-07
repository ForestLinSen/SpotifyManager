//
//  AlbumCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Sen Lin on 2/3/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            AlbumViewController.createLayoutSection()
        }))
        return collectionView
    }()
    
    private var viewModels = [AlbumCellViewModel]()
    private var tracks = [AudioTrack]()
    private var headerViewModel: PlaylistHeaderViewModel?
    
    static func createLayoutSection() -> NSCollectionLayoutSection{
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
                heightDimension: .fractionalHeight(0.07)),
            subitem: item,
            count: 1)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.2)),
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
        ]

        return section
    }
    
    init(album: Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
        
        APICaller.shared.getAlbumDetail(albumID: album.id) {[weak self] result in
            switch result{
            case .success(let albumResponse):
                
                DispatchQueue.main.async {
                    
                    self?.headerViewModel = PlaylistHeaderViewModel(
                        name: albumResponse.name,
                        owner: albumResponse.artists.first?.name ?? "",
                        description: "Release date: \(String.formatteDate(string: albumResponse.release_date))",
                        imageURL: albumResponse.images.first?.url ?? "")
                    
                    self?.viewModels = albumResponse.tracks.items.compactMap({
                        return AlbumCellViewModel(name: $0.name, artist: $0.artists.first?.name ?? "Unknown", preview_url: $0.preview_url)
                    })
                    
                    self?.tracks = albumResponse.tracks.items.compactMap({ albumTrack in
                        return AudioTrack(album: album, artists: album.artists, disc_number: 0, duration_ms: 0, explicit: false, external_urls: [:], id: albumTrack.id, name: albumTrack.name, popularity: 0, preview_url: albumTrack.preview_url, uri: "")
                    })
                    
                    self?.collectionView.reloadData()
                }
                
                
                
            case .failure(_):
                break
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        
        if let viewModel = headerViewModel{
            header.configure(with: viewModel)
        }

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let viewModel = viewModels[indexPath.row]
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = self.tracks[indexPath.row]
        if track.preview_url == nil{
            let alertViewController = UIAlertController(title: "Can't Play This Audio", message: "No preview url for this audio, please choose another one.", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alertViewController, animated: true)
        }else{
            
            PlaybackPresenter.shared.playSingleTrack(from: self, track: track)
        }
    }
    
}


extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
