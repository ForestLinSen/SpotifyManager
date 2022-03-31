//
//  LibraryToggleView.swift
//  SpotifyClone
//
//  Created by Sen Lin on 31/3/2022.
//

import UIKit

protocol LibraryToggleViewDelegate: UIViewController{
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbum(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum LibraryState{
        case Playlist
        case Album
    }
    
    weak var delegate: LibraryToggleViewDelegate?
    var state: LibraryState = .Playlist
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlist", for: .normal)
        button.setTitleColor(.label, for: .normal)
        //button.backgroundColor = .systemRed
        return button
    }()
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Album", for: .normal)
        button.setTitleColor(.label, for: .normal)
        //button.backgroundColor = .systemRed
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylistButton), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbumButton), for: .touchUpInside)
    }
    
    @objc private func didTapPlaylistButton(){
        delegate?.libraryToggleViewDidTapPlaylist(self)
        state = .Playlist
        updateIndicator()
    }
    
    @objc private func didTapAlbumButton(){
        delegate?.libraryToggleViewDidTapAlbum(self)
        state = .Album
        updateIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonHeight = frame.height / 3
        let buttonWidth = frame.width / 5
        let padding = frame.height / 10
        
        playlistButton.frame = CGRect(x: 0, y: padding, width: buttonWidth, height: buttonHeight)
        albumButton.frame = CGRect(x: buttonWidth, y: padding, width: buttonWidth, height: buttonHeight)
        indicatorView.frame = CGRect(x: padding, y: buttonHeight+padding*2, width: buttonWidth, height: buttonHeight/10)
    }
    
    func updateIndicator(){
        let buttonHeight = frame.height / 3
        let buttonWidth = frame.width / 5
        let padding = frame.height / 10
        
        switch state {
        case .Playlist:
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.indicatorView.frame = CGRect(x: padding, y: buttonHeight+padding*2, width: buttonWidth, height: buttonHeight/10)
            }
        case .Album:
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.indicatorView.frame = CGRect(x: padding + buttonWidth, y: buttonHeight+padding*2, width: buttonWidth, height: buttonHeight/10)
            }
        }
        
        
    }
    
}
