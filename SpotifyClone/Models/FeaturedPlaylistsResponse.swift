//
//  FeaturedPlaylistsResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 22/2/2022.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable{
    let message: String
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable{
    let items: [Playlist]
}

struct Playlist: Codable{
    let description: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    let snapshot_id: String
    let tracks: Tracks
    let type: String
    let uri: String
}

struct User: Codable{
    let display_name: String
    let external_urls: [String: String]
    let href: String
    let type: String
    let uri: String

    
}

struct Tracks: Codable{
    let href: String
    let total: Int
}
