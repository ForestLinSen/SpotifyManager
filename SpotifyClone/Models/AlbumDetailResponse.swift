//
//  AlbumDetail.swift
//  SpotifyClone
//
//  Created by Sen Lin on 3/3/2022.
//

import Foundation

struct AlbumDetailResponse: Codable{
    let artists: [Artist]
    let href: String
    let id: String
    let images: [APIImage]
    let name: String
    let total_tracks: Int
    let tracks: AlbumTrackResponse
}

struct AlbumTrackResponse: Codable{
    let items: [AlbumTrack]
}

struct AlbumTrack: Codable{
    let artists: [Artist]
    let id: String
    let name: String
    let preview_url: String // preview the music in 30 seconds
    let track_number: Int // Order of the track in the album
}
