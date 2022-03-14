//
//  SearchQueryResponse.swift
//  SpotifyClone
//
//  Created by Sen Lin on 14/3/2022.
//

import Foundation

struct SearchQueryResponse: Codable{
    let albums: SearchAlbumResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
    let artists: SearchArtistsResponse
}

struct SearchAlbumResponse: Codable{
    let items: [Album]
}

struct SearchPlaylistsResponse: Codable{
    let items: [Playlist]
}

struct SearchTracksResponse: Codable{
    let items: [AudioTrack]
}

struct SearchArtistsResponse: Codable{
    let items: [Artist]
}
