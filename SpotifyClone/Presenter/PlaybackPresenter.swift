//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Sen Lin on 18/3/2022.
//

import Foundation
import UIKit

final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    
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
        self.track = track
        let nav = UINavigationController(rootViewController: vc)
        viewController.present(nav, animated: true, completion: nil)
    }
    
    func startPlayback(from viewController: UIViewController, album: Album){}
    
    func startPlayback(from viewController: UIViewController, playlist: Playlist){}
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
