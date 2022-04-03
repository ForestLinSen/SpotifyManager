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
        
        // group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15)), subitem: item, count: 1)
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturePlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturePlaylistCollectionViewCell else{
            print("Debug: vanilla cell loaded")
            return UICollectionViewCell()
        }
        
        cell.configure(with: FeaturePlaylistCellViewModel(name: "Name", imageURL: URL(string: ""), creatorName: "Wyman"))
        cell.backgroundColor = .systemBlue
        
        return cell
    }
    
    
}
