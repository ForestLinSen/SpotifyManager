//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 10/2/2022.
//

import UIKit

class LibraryViewController: UIViewController {

    private let playlistVC = LibraryPlaylistViewController()
    private let albumVC = LibraryAlbumsViewController()
    private let toggleView = LibraryToggleView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        
        scrollView.delegate = self
        scrollView.backgroundColor = .systemBackground
        scrollView.contentSize = CGSize(width: view.frame.width*2, height: scrollView.frame.height)
        toggleView.delegate = self
        
        addchldren()
        
        
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            switch result{
            case .success(let userPlaylists):
                
                self?.playlistVC.configure(with: userPlaylists.items)
            case .failure(_):
                print("Debug: cannot get user playlists")
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPlaylist))
    }
    
    @objc func addPlaylist(){
        let alert = UIAlertController(title: "New Playlist", message: "Create a new playlist", preferredStyle: .alert)
        
        alert.addTextField{ textField in
            textField.placeholder = "New Playlist"
        }

        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: {[weak self] _ in
            if let title = alert.textFields?.first?.text {
                print("Debug: begin to create a playlist")
                APICaller.shared.createPlaylist(with: title) { success in
                    if(success){
                        print("Debug: successfully creating a new playlist")
                    }else{
                        print("Debug: failed to create the playlist")
                    }
                }
                
            }else{
                let titleAlert = UIAlertController(title: "No Title", message: "Please fill the title", preferredStyle: .alert)
                titleAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self?.present(titleAlert, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55,
                                  width: view.frame.width,
                                  height: view.frame.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height/15)
        
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        albumVC.view.frame = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
    }
    
    func addchldren(){
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        
        playlistVC.didMove(toParent: self)
        
        addChild(albumVC)
        scrollView.addSubview(albumVC.view)
        
        albumVC.didMove(toParent: self)
    }

}

extension LibraryViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > scrollView.frame.width/2{
            toggleView.state = .Album
            toggleView.updateIndicator()
        }else{
            toggleView.state = .Playlist
            toggleView.updateIndicator()
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate{
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbum(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: true)
    }
}
