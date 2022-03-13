//
//  CategoryPlaylistViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 13/3/2022.
//

import UIKit

class CategoryPlaylistViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
        CategoryPlaylistViewController.createCollectionViewLayoutSection()
    }))
    
    private var viewModels = [FeaturePlaylistCellViewModel]()
    private var playlists = [Playlist]()
    private var categoryID: String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(FeaturePlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        APICaller.shared.getCategoryPlaylists(id: categoryID) {[weak self] result in
            switch result{
            case .success(let categoryPlaylistResponse):
                
                
                DispatchQueue.main.async {
                    self?.viewModels = categoryPlaylistResponse.playlists.items.compactMap({
                        return FeaturePlaylistCellViewModel(name: $0.name, imageURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
                    })
                    
                    self?.playlists = categoryPlaylistResponse.playlists.items
                    
                    print("Debug: viewModel counts: \(self?.viewModels.count)")
                    
                    self?.collectionView.reloadData()
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    init(categoryID: String){
        self.categoryID = categoryID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    static func createCollectionViewLayoutSection() -> NSCollectionLayoutSection{
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        // group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.24)), subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    

}

extension CategoryPlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturePlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
