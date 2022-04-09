//
//  LibraryAlbums.swift
//  SpotifyClone
//
//  Created by Sen Lin on 9/4/2022.
//

import Foundation

struct LibraryAlbumsResponse: Codable{
    let items: [LibraryAlbum]
}

struct LibraryAlbum: Codable{
    let album: Album
}
