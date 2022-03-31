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
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var currentIndex = 0
    private var playAllMode = true
    
    private var defaultVolume: Float = 0.5
    
    private var playerViewController: PlayerViewController?
    
    func playSingleTrack(from viewController: UIViewController, track: AudioTrack){
        tracks.removeAll()
        self.track = track
        
        guard let url = URL(string: track.preview_url ?? "") else { return }
        
        player = AVPlayer(url: url)
        player?.volume = defaultVolume
        player?.play()
        
        playerViewController = PlayerViewController()
        playerViewController!.title = track.name
        playerViewController!.delegate = self
        playerViewController!.dataSource = self
        let nav = UINavigationController(rootViewController: playerViewController!)
        
        viewController.present(nav, animated: true)
        
    }
    
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack], trackNumber: Int = 0, playAll: Bool = false){
        //self.track = nil
        
        print("Debug: current index: \(currentIndex)")
        
        for track in tracks {
            if track.preview_url != nil{
                self.tracks.append(track)
            }
        }
        
        playAllMode = playAll
        
        if trackNumber != currentIndex{
            currentIndex = trackNumber
            playAllMode = false
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
        
        if currentIndex < self.tracks.count && currentIndex >= 0{
            if playAllMode { currentIndex += 1}
            
            guard let preview_url = URL(string: tracks[currentIndex].preview_url ?? "") else { return }

            self.player = AVPlayer(url: preview_url)
            self.player?.volume = defaultVolume
            self.player?.play()
            
            playerViewController?.configureWithDataSource()
            playAllMode = true
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
        
        if tracks.isEmpty {
            return track?.name
        }else {
            return tracks[currentIndex].name
        }
    }
    
    var subtitle: String? {
        
        if tracks.isEmpty{
            return track?.artists.first?.name
        }else{
            return tracks[currentIndex].artists.first?.name
        }
        
        
    }
    
    var imageURL: URL? {
        
        if tracks.isEmpty{
            return URL(string: track?.album.images.first?.url ?? "")
        }else{
            return URL(string: tracks[currentIndex].album.images.first?.url ?? "")
        }
        
        
    }
}


extension PlaybackPresenter: PlayerControlsViewDelegate{
    func playerControlsView(_ playerControlView: PlayerControlsView, sliderDidChange value: Float) {
        //print("Debug: slider value: \(value)")
        defaultVolume = value
        player?.volume = defaultVolume
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
        if(!tracks.isEmpty && currentIndex < tracks.count){
            currentIndex += 1
            playAllMode = false
            preparePlayAudio()
        }
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        if(!tracks.isEmpty && currentIndex > 0){
            currentIndex -= 1
            playAllMode = false
            preparePlayAudio()
        }
    }
    
    
}
