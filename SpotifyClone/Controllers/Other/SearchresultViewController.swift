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

protocol SearchResultViewControllerDelegate: UIViewController{
    func showSearchResult(_ controller: UIViewController)
}

class SearchresultViewController: UIViewController{

    weak var delegate: SearchResultViewControllerDelegate?
    private var sections = [SearchSection]()
    private var viewModels = [SearchResultTableViewCellViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }

        switch sections[indexPath.section].results[indexPath.row]{

        case .artist(model: let model):
            break
        case .album(model: let model):
            break
        case .track(model: let model):
           break
        case .playlist(model: let model):
            cell.configure(with: SearchResultTableViewCellViewModel(imageURL: model.images.first?.url ?? "", mainLabel: model.name))
            break
        }

        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch sections[indexPath.section].results[indexPath.row]{
            
        case .artist(model: let model):
            break
        case .album(model: let model):
            let vc = AlbumViewController(album: model)
            delegate?.showSearchResult(vc)
        case .track(model: let model):
            break
        case .playlist(model: let model):
            let vc = PlaylistViewController(playlist: model)
            delegate?.showSearchResult(vc)
        }
    }
}
