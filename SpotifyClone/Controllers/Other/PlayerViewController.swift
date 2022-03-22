//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Sen Lin on 18/3/2022.
//

import UIKit
import SDWebImage

protocol PlayerDataSource: AnyObject{
    var songName: String? { get }
    var subtitle: String?{ get }
    var imageURL: URL?{ get }
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let playbackView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(playbackView)
        configureBarButtons()
        configureWithDataSource()
        
        
        playbackView.delegate = self
    }
    
    private func configureWithDataSource(){
        imageView.sd_setImage(with: dataSource?.imageURL)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.width)
        playbackView.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2)
    }
    
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction(){
        // Actions
    }

}

extension PlayerViewController: PlayerControlsViewDelegate{
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play button tapped")
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play forward tapped")
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play backward tapped")
    }
    
    
}
