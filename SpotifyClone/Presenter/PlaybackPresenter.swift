//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Sen Lin on 18/3/2022.
//

import Foundation
import UIKit

final class PlaybackPresenter{
    static func startPlayback(from viewController: UIViewController, track: AudioTrack){
        let vc = PlayerViewController()
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func startPlayback(from viewController: UIViewController, album: Album){}
    
    static func startPlayback(from viewController: UIViewController, playlist: Playlist){}
}
