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
        
        let vc = PlayerViewController()
        vc.title = tracks[currentIndex].name
        vc.delegate = self
        vc.dataSource = self
        let nav = UINavigationController(rootViewController: vc)
        
        viewController.present(nav, animated: true)
        
        

//        let assets: [AVURLAsset] = tracks.compactMap { audioTrack in
//            guard let preview_url = audioTrack.preview_url, let url = URL(string: preview_url) else { return nil }
//            return AVURLAsset(url: url)
//        }
//
//
//        let vc = PlayerViewController()
//        vc.title = currentTrack?.name
//        vc.delegate = self
//        vc.dataSource = self
//        let nav = UINavigationController(rootViewController: vc)
//
//        var items: [AVPlayerItem] = assets.compactMap { asset in
//            return AVPlayerItem(asset: asset)
//        }
//
//        self.playerQueue = AVQueuePlayer(playerItem: items.first)
//        items.removeFirst()
//
//        self.playerQueue?.volume = 0.2
//        self.playerQueue?.play()
//
//        DispatchQueue.global(qos: .background).async {[weak self] in
//            items.forEach { item in
//                print("Debug: Add queue: \(item)")
//                self?.playerQueue?.insert(item, after: self?.playerQueue?.items().last)
//            }
//        }
//
//
//        viewController.present(nav, animated: true){[weak self] in
//
//            self?.playerQueue = AVQueuePlayer(items: items)
//            self?.playerQueue?.volume = 0.5
//            self?.playerQueue?.play()
//        }

    }
    
    @objc private func preparePlayAudio(){
        
        print("Debug: start to play the next audio")
        
        if currentIndex < self.tracks.count{
            guard let preview_url = URL(string: tracks[currentIndex].preview_url ?? "") else { return }
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
        
        if let player = player{
            if player.timeControlStatus == .playing{
                player.pause()
            }else{
                player.play()
            }
            print("Debug: play button tapped")
        }
        
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play forward tapped")
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        print("Debug: play backward tapped")
    }
    
    
}
