//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 10/2/2022.
//

import UIKit

enum BrowseSectionType{
    case newReleases(viewModels: [NewReleasesCellViewModel]) // 0
    case featuredPlaylists(viewModels: [FeaturePlaylistCellViewModel]) // 1
    case recommendedTracks(viewModels: [RecommendationCellViewModel]) // 2
    
    var title: String {
        switch self {
        case .newReleases(let viewModels):
            return "New Releases"
        case .featuredPlaylists(let viewModels):
            return "Featured Playlists"
        case .recommendedTracks(let viewModels):
            return "Recommended Tracks"
        }
        
    }
}


class HomeViewController: UIViewController{
    
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            return HomeViewController.createCollectionLayout(section: sectionIndex)
        }))
    
    private var sections = [BrowseSectionType]()
    private var newAlbums: [Album]?
    private var playlists: [Playlist]?
    private var tracks: [AudioTrack]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        
        layoutCollectionView()
        fetchData()
        fetchUserProfile()
        addLongTapGesture()
        
    }
    
    private func addLongTapGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        
        // avoid gesture triggerd too many times
        guard gesture.state == .began else{
            return
        }
        
        let position = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: position) else { return }
        
        if indexPath.section == 2{
            
            guard let model = tracks?[indexPath.row] else { return }
            
            
            let sheet = UIAlertController(title: model.name, message: "Do you want to add this track to your playlist?", preferredStyle: .actionSheet)
            
            
            sheet.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
                
                DispatchQueue.main.async {
                    let vc = LibraryPlaylistViewController()
                    vc.selectionHandler = {playlist in
                        APICaller.shared.addTrackToPlaylist(playlistID: playlist.id, trackURI: model.uri) { success in
                            
                            DispatchQueue.main.async {
                                self?.dismiss(animated: true)
                            }
                        }
                    }
                    
                    vc.title = "Select a playlist"
                    self?.present(UINavigationController(rootViewController: vc), animated: true)
                }

            }))
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(sheet, animated: true)
        }
        
        
        print("Debug: long pressed")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func layoutCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    /// cache user profile data
    private func fetchUserProfile(){
        if(UserDefaults.standard.object(forKey: "userProfile") == nil){
            APICaller.shared.getCurrentUserProfile { result in
                switch result{
                case .success(let userProfile):
                    do{
                        let data = try JSONEncoder().encode(userProfile)
                        UserDefaults.standard.set(data, forKey: "userProfile")
                    }catch{
                        print("Debug: cannot cache user profile data")
                    }
                case .failure(_):
                    print("Debug: cannot found user profile data")
                }
            }
        }
    }
    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featurePlaylists: FeaturedPlaylistsResponse?
        var recommendations: RecommendationResponse?
        
        // New Releases
        APICaller.shared.getReleases {[weak self] result in
            
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print("Debug: error in get newReleases \(error)")
            }
        }
        
        // Featured Playlists
        APICaller.shared.getFeaturedPlaylists{ result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                featurePlaylists = model
            case .failure(let error):
                print("Debug: error in get newReleases \(error)")
            }
        }
        
        // Recommendation
        APICaller.shared.getRecommendation{ result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                recommendations = model
            case .failure(let error):
                print("Debug: error in get newReleases \(error)")
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            guard let self = self else { return }
            
            guard let newAlbum = newReleases?.albums.items,
                  let playlists = featurePlaylists?.playlists.items,
                  let tracks = recommendations?.tracks else{
                      return
                  }
            
            self.newAlbums = newAlbum
            self.playlists = playlists
            self.tracks = tracks
            
            self.configureModels(newAlbums: self.newAlbums!, playlists: self.playlists!, tracks: self.tracks!)
        }
    }
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]){
        // configure models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleasesCellViewModel(name: $0.name,
                                            artworkURL: URL(string: $0.images.first?.url ?? ""),
                                            numberOfTracks: $0.total_tracks,
                                            artistName: $0.artists.first?.name ?? "Unknown",
                                            albumID: $0.id)
        })))
        
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            return FeaturePlaylistCellViewModel(name: $0.name,
                                                imageURL: URL(string: $0.images.first?.url ?? ""),
                                                creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendedTracks(viewModels: tracks.compactMap({
            return RecommendationCellViewModel(trackName: $0.name,
                                               artistName: $0.artists.first?.name ?? "",
                                               imageURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
        
        collectionView.reloadData()
        
    }
    
    
    static func createCollectionLayout(section: Int) -> NSCollectionLayoutSection{
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        switch section{
        case 0:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.85),
                    heightDimension: .fractionalHeight(0.45)),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        case 1:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)),
                subitem: item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.65),
                    heightDimension: .fractionalHeight(0.6)),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        case 2:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.1)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        default:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)),
                subitem: item,
                count: 1)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.85),
                    heightDimension: .fractionalHeight(0.3)),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
    }
    
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        
        switch type{
            
        case .newReleases(viewModels: let viewModels):
            return viewModels.count
        case .featuredPlaylists(viewModels: let viewModels):
            return viewModels.count
        case .recommendedTracks(viewModels: let viewModels):
            return viewModels.count
        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                        withReuseIdentifier: TitleHeaderCollectionReusableView.identifier,
                                                                           for: indexPath) as? TitleHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = sections[indexPath.section]
        
        header.configure(with: section.title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type{
        case .newReleases(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(viewModels: let viewModels):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturePlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .recommendedTracks(viewModels: let viewModels):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
                                                                , for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        
        switch section{
            
        case .newReleases(viewModels: let viewModels):
            if let album = self.newAlbums?[indexPath.row]{
                let vc = AlbumViewController(album: album)
                vc.title = album.name
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
                
            }
        case .featuredPlaylists(viewModels: let viewModels):
            if let playlist = self.playlists?[indexPath.row]{
                let vc = PlaylistViewController(playlist: playlist)
                vc.title = playlist.name
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
            }
            
        case .recommendedTracks(viewModels: let viewModels):
            
            if let track = self.tracks?[indexPath.row]{
                if track.preview_url == nil{
                    let alertViewController = UIAlertController(title: "Can't Play This Audio", message: "No preview url for this audio, please choose another one.", preferredStyle: .alert)
                    alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(alertViewController, animated: true)
                }else{
                    
                    PlaybackPresenter.shared.playSingleTrack(from: self, track: track)
                }
                
            }
        }
        
    }
}
