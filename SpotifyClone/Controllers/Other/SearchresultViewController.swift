//
//  SearchresultViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 15/3/2022.
//

import UIKit

struct SearchSection{
    let title: String
    let results: [SearchResult]
}

class SearchresultViewController: UIViewController{

    private var sections = [SearchSection]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .systemTeal
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]){
        
        sections.removeAll()
        
        var artists = [SearchResult]()
        var album = [SearchResult]()
        var track = [SearchResult]()
        var playlist = [SearchResult]()
        
        results.forEach { result in
            switch result{
            case .artist(_):
                artists.append(result)
            case .album(_):
                album.append(result)
            case .track(_):
                track.append(result)
            case .playlist(_):
                playlist.append(result)
            }
        }
        
        sections.append(SearchSection(title: "Artist", results: artists))
        sections.append(SearchSection(title: "Album", results: album))
        sections.append(SearchSection(title: "Playlist", results: playlist))
        sections.append(SearchSection(title: "Track", results: track))

        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }

    }
}

extension SearchresultViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        var name: String = ""

        switch sections[indexPath.section].results[indexPath.row]{

        case .artist(model: let model):
            name = model.name
        case .album(model: let model):
            name = model.name
        case .track(model: let model):
            name = model.name
        case .playlist(model: let model):
            name = model.name
        }
        
        config.text = name
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
