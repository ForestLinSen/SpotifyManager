//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Sen Lin on 18/3/2022.
//

import Foundation
import UIKit
import AVFoundation

final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var currentIndex = 0
    
    private var playerViewController: PlayerViewController?
    
    private var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty{
            return track
        }else if !tracks.isEmpty{
            return tracks.first
        }
        
        return nil
    }
    
    func startPlayback(from viewController: UIViewController, track: AudioTrack){

        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        self.track = track
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true){[weak self] in
            guard let url = URL(string: track.preview_url ?? "") else {
                print("Debug: no preview url")
                return
            }

            self?.player = AVPlayer(url: url)
            self?.player?.volume = 0.5
            self?.player?.play()
        }
    }
    
    func startPlayback(from viewController: UIViewController, album: Album){
        
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]){
        self.track = nil
        for track in tracks {
            if track.preview_url != nil{
                self.tracks.append(track)
            }
        }
        
        preparePlayAudio()
        
        playerViewController = PlayerViewController()
        playerViewController!.title = tracks[currentIndex].name
        playerViewController!.delegate = self
        playerViewController!.dataSource = self
        let nav = UINavigationController(rootViewController: playerViewController!)
        
        viewController.present(nav, animated: true)

    }
    
    @objc private func preparePlayAudio(){
        
        print("Debug: start to play the next audio")
        
        if currentIndex < self.tracks.count{
            guard let preview_url = URL(string: tracks[currentIndex].preview_url ?? "") else { return }
            
            playerViewController?.configureWithDataSource()
            
            self.player = AVPlayer(url: preview_url)
            self.player?.volume = 0.2
            self.player?.play()
            currentIndex += 1
        }else{
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(preparePlayAudio), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)

    }
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PlaybackPresenter: PlayerDataSource{
    var songName: String? {
        return tracks[currentIndex].name
    }
    
    var subtitle: String? {
        return tracks[currentIndex].artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: tracks[currentIndex].album.images.first?.url ?? "")
    }
}


extension PlaybackPresenter: PlayerControlsViewDelegate{
    func playerControlsView(_ playerControlView: PlayerControlsView, sliderDidChange value: Float) {
        //print("Debug: slider value: \(value)")
        player?.volume = value
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        
        if let player = player{
            if player.timeControlStatus == .playing{
                player.pause()
            }else{
                player.play()
            }
        }
        
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play forward tapped")
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play backward tapped")
    }
    
    
}
