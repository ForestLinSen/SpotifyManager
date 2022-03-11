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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print("Debug: search controller text: \(text)")
    }

}
