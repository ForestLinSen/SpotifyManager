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
        self.tracks = tracks
        self.track = nil
        
        let items: [AVPlayerItem] = tracks.compactMap { audioTrack in
            guard let preview_url = audioTrack.preview_url, let url = URL(string: preview_url) else { return nil}
            return AVPlayerItem(url: url)
        }

        
        let vc = PlayerViewController()
        vc.title = currentTrack?.name
        vc.delegate = self
        vc.dataSource = self
        viewController.present(vc, animated: true){[weak self] in
            self?.playerQueue = AVQueuePlayer(items: items)
            self?.playerQueue?.volume = 0.5
            self?.playerQueue?.play()
        }
    }
}

extension PlaybackPresenter: PlayerDataSource{
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album.images.first?.url ?? "")
    }
}


extension PlaybackPresenter: PlayerControlsViewDelegate{
    func playerControlsView(_ playerControlView: PlayerControlsView, sliderDidChange value: Float) {
        //print("Debug: slider value: \(value)")
        player?.volume = value
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        if player?.timeControlStatus == .playing{
            player?.pause()
        }else{
            player?.play()
        }
        print("Debug: play button tapped")
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play forward tapped")
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play backward tapped")
    }
    
    
}
