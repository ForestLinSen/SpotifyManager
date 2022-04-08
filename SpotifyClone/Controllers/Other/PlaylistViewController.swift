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
    private var tracks = [AudioTrack]()
    
    public var isOwner = false
    var pan: UIPanGestureRecognizer?
    var panPoint: CGPoint?
    
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.backgroundColor = .systemRed
        
        return label
    }()
    
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
                    playlistResponse.tracks.items.compactMap { playlistTrack in
                        self?.tracks.append(playlistTrack.track)
                        self?.viewModels.append(RecommendationCellViewModel(trackName: playlistTrack.track.name,
                                                                            artistName: playlistTrack.track.artists.first?.name ?? "-",
                                                                            imageURL: URL(string: playlistTrack.track.album.images.first?.url ?? "")))
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShareButton))
        
        addPanGesture()
        view.addSubview(deleteLabel)
    }
    
    private func addPanGesture(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func onPan(_ gesture: UIPanGestureRecognizer){
        pan = gesture
        panPoint = pan!.translation(in: collectionView)

        //print("Debug: pan x:\(p?.x)")
        
        viewDidLayoutSubviews()

    }
    
    @objc func didTapShareButton(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else { return }
        
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
        
            
        //let indexPath = collectionView.indexPathForItem(at: pan?.location(in: collectionView))

        deleteLabel.frame = CGRect(x: 200, y: 200, width: abs(panPoint?.x ?? 0), height: 50)
        //print("Debug: width \(abs(pan!.translation(in: collectionView).x))")

        print("Debug: pan x:\(panPoint?.x)")
        
        
        
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
                heightDimension: .fractionalHeight(0.11)),
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
        
        // swipe to delete
        if isOwner{
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView else {
                    return UICollectionReusableView()
                }
        
        if let viewModel = headerViewModel{
            header.configure(with: viewModel)
            header.delegate = self
        }
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let trackNumber = indexPath.row
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks, trackNumber: trackNumber)

    }
    
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
