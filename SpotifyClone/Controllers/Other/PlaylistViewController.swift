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
    var panPoint: CGPoint = CGPoint(x: 0, y: 0)
    
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
        
        
        if let pan = pan {
            guard let indexPath = collectionView.indexPathForItem(at: pan.location(in: collectionView)) else{ return }

            guard let attribute = collectionView.layoutAttributesForItem(at: indexPath) else{ return }

            let rect = collectionView.convert(attribute.frame, to: view)
            let point = collectionView.convert(attribute.frame.origin, to: view)
            let cellHeight = rect.height
            let cellY = point.y
            
            if panPoint.x < 0{
                
                let panWidth = abs(panPoint.x)
                
                deleteLabel.frame = CGRect(x: view.frame.width-min(panWidth, 150), y: cellY, width: 150, height: cellHeight)
                
                if pan.state == .ended || pan.state == .possible{
                    
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if panWidth < 50{
                            self?.deleteLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                        }else{
                            self?.deleteLabel.frame = CGRect(x: (self?.view.frame.width ?? 0)-150, y: cellY, width: 150, height: cellHeight)
                        }
                    }

                }
            }
        }
        
        
        if let state = pan?.state{
            switch state{
                
            case .possible:
                print("possible")
            case .began:
                print("began")
            case .changed:
                print("changed")
            case .ended:
                print("ended")
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed")
            @unknown default:
                print("default")
            }
        }
        
        
        
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
