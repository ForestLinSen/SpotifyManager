//
//  CategoryPlaylist.swift
//  SpotifyClone
//
//  Created by Sen Lin on 13/3/2022.
//

import Foundation

struct CategoryPlaylistsResponse: Codable{
    let playlists: CategoryPlaylists
}

struct CategoryPlaylists: Codable{
    let href: String
    let items: [Playlist]
}
