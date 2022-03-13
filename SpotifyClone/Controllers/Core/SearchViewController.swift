//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 10/2/2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    private let searchController: UISearchController = {
        let results = UIViewController()
        results.view.backgroundColor = .systemBrown
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Songs, Artists, Albums..."
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
        SearchViewController.createCollectionViewSection()
    }))
    
    private let genreColors: [UIColor] = [
        .systemPink,
        .systemGreen,
        .systemBrown,
        .systemRed,
        .orange,
        .systemPurple,
        .systemGray,
        .systemBlue
        
    ]
    
    private var viewModels = [CategoryViewModel]()
    
    static func createCollectionViewSection() -> NSCollectionLayoutSection{
        // item
        let item = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        // group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.15)),
            subitem: item,
            count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        APICaller.shared.getCategories {[weak self] result in
            switch result{
                
            case .success(let categoryResponse):

                DispatchQueue.main.async {
                    self?.viewModels = categoryResponse.categories.items.compactMap({
                        return CategoryViewModel(name: $0.name, image: $0.icons.first?.url ?? "" , href: $0.href, id: $0.id)
                    })
                    self?.collectionView.reloadData()
                }

            case .failure(_):
                break
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print("Debug: search controller text: \(text)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let viewModel = viewModels[indexPath.row]
        
        cell.configure(title: viewModel.name, imageURL: viewModel.image, color: genreColors.randomElement()!)
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let viewModel = viewModels[indexPath.row]
        print("Debug: did select item id: \(viewModel.id)")
        
        let vc = CategoryPlaylistViewController(categoryID: viewModel.id)
        vc.title = viewModel.name
        navigationController?.pushViewController(vc, animated: true)

    }
}
